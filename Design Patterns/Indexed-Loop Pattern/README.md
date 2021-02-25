# Indexed-Loop Pattern

## Context
The Indexed-Loop Pattern can be applied whenever an unbounded data structure (e.g., an array or a list) is used in a smart contract. 

``Applies to: [X] EOSIO    [X] Ethereum    [] Hyperledger Fabric``

## Problem
The objective of the Indexed-Loop Pattern is to deal with the abortion of smart contract execution and denial of service attacks related to unbounded data structures. The problem is that the consumation of all available computational resources for smart contract execution can interrupt iterations over an unlimited data structure (i.e., unlimited bulk operations). Resulting in e.g., out-of-gas exceptions in Ethereum-like platforms or exceeding the threshold for smart contract execution time in EOSIO. Exceeding the available computational resources can lead to denial of service, because some elements are never processed at the end of the unbounded data structure. In case of an exception thrown during the iteration over an unbounded data structure (e.g., due to an out-of-gas exception or a timeout), the iteration should be interrupted and be continuable with the next call.

## Forces
The forces involved in the Indexed-Loop Pattern are technical soundness, resource efficiency and code efficiency. Technical soundness can be improved by the application of the Indexed-Loop Pattern as risks associated with unbounded data structures are mitigated by enabling the smart contract to resume with the next iteration with the next call. At the same time code efficiency and resource efficiency is reduced as an additional mechanism to check for sufficient gas for the next iteration needs to be implemented.

## Solution
To avoid out-of-gas exceptions and continue an iteration over an unbounded, iterable data structure, developers should implement a mechanism to check if sufficient gas is available for the next iteration and an index variable that stores the index of the last element of the iteratable data structure that was successfully processed. When resuming the iteration over the unbounded data structure through another call of the smart contract function, the loop continues at the value stored in the index variable. If a procedure to be executed within the loop fails multiple times for a certain index, this failure should be marked to prevent denial of service and proceed with subsequent elements of the iterable data structure.

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
Before iterations over an unbounded data structure will exceed the available amount of gas, the iteration is aborted can be resumed in a subsequent invocation of the same function at the index stored in an index variable. To completely iterate over the data structure as intended, more than one call of the function might be necessary. Due to additional operations (e.g., updating the index variable), the use of the Indexed-Loop Pattern increases gas cost for deployment and execution. Furthermore, the user who triggers the iteration must pay for the execution themselves. Such cost may cause an issue regarding the fair distribution of costs (see [Pull Pattern](/Design%20Patterns/Pull%20Pattern/README.md#context)).

## Rationale
By implementing an index variable that points to the last successfully processed element of the iterable data structure, the effects of an out-of-gas exceptions can be mitigated because operations that exceed the gas limit can be continued by the next function call.

## Related Patterns
[Pull Pattern](/Design%20Patterns/Pull%20Pattern/README.md#context)

## Known Uses
[FoMo3Dlong](https://etherscan.io/address/0xa62142888aba8370742be823c1782d17a0389da1) (lines 565 ff)
