# Pull Pattern
## Context
A data structure (e.g., a linked list) keeps an unlimited number of elements (e.g., accounts for payments). This data structure is to be iterated over to perform operations (e.g., transferring assets to accounts managed in the iterable data structure).

``Applies to: [] EOSIO    [X] Ethereum    [] Hyperledger Fabric``
## Problem
Abortions of iterations over unbounded data structures can lead to denial of service (e.g., due to out-of-gas conditions), which renders the smart contract ineffective. Moreover, upon each call, operations are executed iteratively for all elements in the unbounded data structure, causing computational overhead. The computational overhead can increase the cost of the functional execution in distributed ledgers that apply a cost schedule for computations (e.g., Ethereum). The aim of the Pull Pattern is to avoid the risks connected to unbounded data structures (e.g., for denial-of-service attacks) and to reduce computational overhead per function call.

## Forces
The forces involved in the Pull Pattern are fairness, complexity, and code efficiency, particularly required interactions. The application of the Pull Pattern reduces the complexity of the smart contract as the smart contract itself does not need to iterate over an unbounded data structure. Moreover, the distribution of costs for the execution of the respective smart contract code is done more fairly, as each account pays for the execution. This comes at the cost of the number of required interactions because each account needs to invoke the pull mechanism. 

## Solution
Instead of iterating over all elements of an unbounded data structure (e.g., to transfer assets to the accounts stored in the iterable data structure), implement a method that allows users to execute the function via a pull mechanism. This pull mechanism executes the function for one element of the iterable data structure; for example, it transfers the balance associated with the caller address to the caller account. In Ethereum, the pull mechanism must be protected against reentrancy (e.g., by using the Checks-Effects-Interactions Pattern or the Mutex Pattern).

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
Unbounded mass operations are avoided and the invoking smart contract or user retains control over the associated gas costs. The smart contract does only execute those functions relevant to a certain element of the iterable data structure. Moreover, the user involvement is increased.

## Rationale
By abandoning iterations over unbounded data structures, unbounded mass operations and resulting unintended abortion of the operations (e.g., by out-of-gas conditions) are avoided. Using the Pull Pattern, direct retrieval of required data (e.g., from a mapping in Solidity) is possible, and no helper data structures for the iteration are required (e.g., an array that stores all keys of a HashMap).

## Related Patterns
[Checks-Effects-Interactions Pattern](/Idioms/Checks-Effects-Interactions%20Pattern/README.md#context), [Indexed-Loop Pattern](/Design%20Patterns/Indexed-Loop%20Pattern/README.md#context)

## Known Uses
[CryptoPunksMarket](https://etherscan.io/address/0xb47e3cd837dDF8e4c57F05d70Ab865de6e193BBB#code) (lines 190ff)
