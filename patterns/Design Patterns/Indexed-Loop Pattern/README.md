# Indexed-Loop Pattern

## Context
A data structure (e.g., a linked list) keeps an unlimited number of elements (e.g., accounts for payments). This data structure is to be iterated over to perform operations (e.g., transferring assets to accounts managed in the iterable data structure).

``Applies to: [X] EOSIO    [X] Ethereum    [] Hyperledger Fabric``

## Problem
The full consumption of available resources for smart contract execution (e.g., gas in Ethereum-based blockchains) can interrupt iterations over an unlimited data structure (i.e., unlimited bulk operations). A persistent exceed in the available resources during the iteration over a data structure can lead to denial-of-service, because some elements will never be processed. The aim of the Indexed-Loop Pattern is to make iterations over unbounded data structures continuable after abortion.

## Forces
The forces involved in the Indexed-Loop Pattern are technical soundness, resource efficiency and code efficiency. Technical soundness can be improved by the application of the Indexed-Loop Pattern as risks associated with unbounded data structures are mitigated by enabling the smart contract to resume with the next iteration with the next call. At the same time code efficiency and resource efficiency are reduced as an additional mechanism to check for sufficient gas for the next iteration needs to be implemented.

## Solution
IImplement a mechanism to check if sufficient gas is available for the next iteration and an index variable that references the last successfully processed element of the iterable data structure. In the subsequent call to the smart contract function, the loop continues at the element referenced by the index variable. If a procedure to be executed within the loop fails multiple times for a certain index, this failure should be marked to prevent denial of ser-vice and proceed with subsequent elements of the iterable data structure.

## Example
### Wrong
```Solidity
pragma solidity ^0.7.0;

contract IndexedLoopAntipattern {
    struct Payee {
        address payable addr;
        uint256 value;
    }
    
    Payee[] payees;
    //...
    receive() external payable {
        Payee memory p = Payee(msg.sender, msg.value);
        payees.push(p);
    }
    
    function payout() public {
        uint256 i = 0;
        while(i < payees.length) {
            // The require statement will block the loop if an asset transfer always fails
            require(payees[i].addr.{value:payees[i].value}(),
                       "An error occured.");
            i++;
        }
    }
}

```
### Correct
```Solidity
pragma solidity ^0.7.0;

contract IndexedLoopPattern {
    struct Payee {
        address payable addr;
        uint256 value;
    }

    Payee[] payees;
    uint256 nextPayeeIndex;
    //...
    function payout() public payable {
        uint256 totalGasConsumed = 0;
        // Estimated amount of gas required for each iteration (must not be smaller than the actually consumed gas)
        uint256 gasPerIteration = 42000;
        // Minimum amount of gas required to execute the code after the loop
        uint256 gasForPostLoopExecution = 1650;
        uint256 gasRequired = gasPerIteration + gasForPostLoopExecution;

        while(nextPayeeIndex < payees.length && gasleft() >= gasRequired
            && totalGasConsumed + gasRequired < block.gaslimit) {

            uint256 val = payees[nextPayeeIndex].value;
            payees[nextPayeeIndex].value = 0;
            // Avoid transferring assets from within a loop because of untrustful external calls
            payees[nextPayeeIndex].addr.send(val);
            totalGasConsumed = totalGasConsumed + gasPerIteration;
            nextPayeeIndex++;
        }
        
        if(nextPayeeIndex == payees.length) {
             nextPayeeIndex = 0;
        }
    }
}
```
The individual gas costs for _gasPerIteration_ and _gasForPostLoop_ have been manually calculated. The Indexed-Loop Pattern implemented in the above example assumes that all asset transfers succeed and **does not protect from wallet griefing**. To protect from wallet griefing, mechanisms to keep track of failed transactions and the corresponding recipient accounts must be implemented to adjust the index accordingly and prevent denial of service. For such checks, the return value of the asset transfer function in line 24 must be considered.

## Resulting Context
Before iterations over an unbounded data structure will exceed the available resources, the iteration is aborted and can be resumed in a subsequent invocation of the same function at the element referenced by the index variable. To completely iterate over the data structure, more than one call of the function might be necessary. Because of additional operations (e.g., updating the index variable) to be implemented, the use of the Indexed-Loop Pattern increases cost for deployment and execution.

## Rationale
By implementing an index variable that references the last successfully processed element of the iterable data structure, the abortion of iterations over unbounded data structures can be mitigated by continuing the respective iteration in subsequent calls.

## Related Patterns
[Pull Pattern](/Design%20Patterns/Pull%20Pattern/README.md#context)

## Known Uses
[FoMo3Dlong](https://etherscan.io/address/0xa62142888aba8370742be823c1782d17a0389da1) (lines 565 ff)
