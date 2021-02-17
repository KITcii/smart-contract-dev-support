# Pull Pattern
## Context
Unlimited mass operations can occur when a developer uses an iteratable data structure (such as a list) to store an unlimited number of elements (such as accounts) that are iterated to perform certain operations (such as transferring assets to accounts maintained in the iteratable data structure).

## Problem
When iterating over an unbounded data structure where user accounts are maintained (e.g., for payments), the smart contract execution may be aborted because of too many iterations. Such abortion of the iteration can lead to denial of service, which renders the smart contract function ineffective. Individual users must pay for the execution of all procedures within the loop in distributed ledger implementing a cost model (e.g., Ethereum). Such cost may cause an issue regarding the fair distribution of costs.

## Forces
Users must execute the smart contract function by themselves (e.g., to receive payments) and cost for smart contract execution (e.g., in gas) should be borne by the executing users themselves. Furthermore, the risk for denial of service of the smart contract should be decreased by reducing the complexity of the smart contract function. Vulnerabilities for reentrancy should be prevented. 

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
Unbounded mass operations are avoided and the invoking smart contract or user retains control over the associated gas costs. The smart contract does only execute those functions relevant for a certain element of the iterable data structure.

## Rationale
By abandoning unbounded iteratable data structures, it is possible to avoid unbounded mass operations and, thus, unintended abortion of the operations (e.g., through an out-of-gas exceptions). Using the Pull Pattern, direct retrieval of required data (e.g., from a mapping in Solidity) is possible and no helper data structures for the iteration are required (e.g., an array that stores all keys of a HashMap).

## Related Patterns
[Indexed-Loop Pattern](/Design%20Patterns/Indexed-Loop%20Pattern/README.md#context), [Checks-Effects-Interactions Pattern](/Idioms/Checks-Effects-Interactions%20Pattern/README.md#context), [Mutex Pattern](/Design%20Patterns/Mutex%20Pattern/README.md#context)

## Known Uses
[CryptoPunksMarket](https://etherscan.io/address/0xb47e3cd837dDF8e4c57F05d70Ab865de6e193BBB#code) (lines 190ff)
