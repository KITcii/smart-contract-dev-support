# Pull Pattern
## Context
The Pull Pattern is applicable when handling unbounded iterable data structures (such as lists) to store an unlimited number of elements (e.g., accounts for payments). These data structures may be iterated to perform certain operations (such as transferring assets to accounts maintained in the iterable data structure).

``Applies to: [] EOSIO    [X] Ethereum    [] Hyperledger Fabric``
## Problem
The objective of the Pull Pattern is to avoid the risks connected to unbounded data structures such as denial of service attacks and to redistribute the costs more fairly. One risk connected to the Pull Pattern is abortion of smart contract execution caused by too many iterations. Such abortion of the iteration can lead to denial of service, which renders the smart contract ineffective. Moreover, individual users must pay for the execution of all procedures within the loop in distributed ledgers implementing a cost model (e.g., Ethereum). Such cost may cause an issue regarding the fair distribution of costs. Users should execute the smart contract function by themselves (e.g., to receive payments) and cost for smart contract execution (e.g., in gas) should be borne by the executing users themselves.

## Forces
The forces involved in the Pull Pattern are fairness, complexity and code efficiency particularly required interactions. The application of the pull pattern reduces complexity of the smart contract as the smart contract itself does not need to iterate over an unbounded data structure. Moreover, the distribution of costs for the execution of the respective smart contract code is done more fairly as each account themselves pays for the execution. This comes at the cost of the number of required interactions because each account needs to invoke the pull mechanism. 

## Solution
Instead of implementing a loop to iterate over all elements of the iterable data structure (e.g., to transfer assets to the accounts stored in the iterable data structure), implement a method that allows users to execute the function via a pull mechanism with no iterations. This pull mechanism only executes the function for one element of the iterable data structure. This function must be protected against reentrancy (e.g., by using the Checks-Effects-Interactions Pattern or the Mutex Pattern).

## Example
### Wrong
```Solidity
pragma solidity ^0.7.0;

contract PullAntipattern {
    address payable[] clients;
    mapping (address => uint256) public balances;
    //...
    function payout() public {
        for (uint256 i = 0; i < clients.length; i++) {
            clients[i]. call{value: balances[clients[i]]}("");
        }
    }
}
```
### Correct
```Solidity
pragma solidity ^0.7.0;

contract PullPattern {
    mapping (address => uint256) public balances;
    //...
    function payout() public {
        require(balances[msg.sender] > 0, "No balance available.");

        uint256 amount = balances[msg.sender];
        balances[msg.sender] = 0;
        msg.sender.call{value: amount}("");
    }
}
```
## Resulting Context
Unbounded mass operations are avoided and the invoking smart contract or user retains control over the associated gas costs. The smart contract does only execute those functions relevant for a certain element of the iterable data structure. Moreover, the user involvement is increased.

## Rationale
By abandoning unbounded iteratable data structures, it is possible to avoid unbounded mass operations and, thus, unintended abortion of the operations (e.g., through an out-of-gas exceptions). Using the Pull Pattern, direct retrieval of required data (e.g., from a mapping in Solidity) is possible and no helper data structures for the iteration are required (e.g., an array that stores all keys of a HashMap).

## Related Patterns
[Checks-Effects-Interactions Pattern](/Idioms/Checks-Effects-Interactions%20Pattern/README.md#context), [Indexed-Loop Pattern](/Design%20Patterns/Indexed-Loop%20Pattern/README.md#context)

## Known Uses
[CryptoPunksMarket](https://etherscan.io/address/0xb47e3cd837dDF8e4c57F05d70Ab865de6e193BBB#code) (lines 190ff)
