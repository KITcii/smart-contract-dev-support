# Façade Pattern
## Context
Interactions with a system composed of multiple smart contracts are required.

``Applies to: [X] EOSIO    [X] Ethereum    [] Hyperledger Fabric``

## Problem
In favor of separation of concerns, multiple smart contracts with individual logic are often used. Manually orchestrating the connection of the individual logic blocks of this smart contract into a composed logic thus requires multiple invocations of smart contracts. However, manually performing these calls to provision a composed application logic is prone to errors and flaws (e.g., due to misspellings or neglected side effects across smart contracts). In Ethereum-based blockchains, interacting with smart contract systems becomes even more challenging when updated smart contracts are redeployed because their addresses change. The addresses need to be updated in all systems that make calls to the outdated contract. The goal of the facade pattern is to simplify and make more secure interactions with a smart contract system, to implement logic that is composed of functions from different smart contracts, and to make it easier to maintain smart contracts.

## Forces
The forces involved in the Façade Pattern are maintainability, manual effort, and resource efficiency. Maintainability is improved by offering a single point of entry through the Façade Contract while simultaneously reducing manual effort through automation. The application of the Façade Pattern comes at the cost of resource efficiency through the deployment of an additional smart contract, the Façade Contract.

## Solution
There are two roles smart contracts can take in the Façade Pattern: Satellite or Façade Contract. Satellites are smart contracts that represent a module in the contract system. The Façade Contract serves as an entry point to interact with the Satellites. Each Satellite’s address is registered with the Façade Contract. With only one call to the Façade Contract, a sequence of calls to functions of the individual Satellites can be executed. To execute logic composed of a sequence of smart contract functions, the Façade Contract loads the instance(s) of the required Satellites using the registered smart contract addresses and calls targeted functions in a defined order. All interactions with Satellites and potential errors are handled by the Façade Contract.

## Example
Wrong | Correct
------------ | -------------
![Wrong](Façade%20Pattern%20-%20Direct%20Calls%20without%20Façade.png) | ![Correct](Façade%20Pattern%20-%20Direct%20via%20Façade.png)

## Resulting Context
The Façade Contract offers an entry point for the execution of application logic composed of multiple logic blocks provided by function of Satellites and, thus, eases the execution of composed application logic. By using individual logic blocks in different Satellites, a high degree of separation of concerns can be achieved and maintainability of individual logic blocks is improved. Moreover, error handling can be managed in a uniform way and must not be individually implemented in each system using composed smart contract logic. However, the deployment of Façade Contract causes additional cost in distributed ledgers like EOS or Ethereum.

## Rationale
Orchestrating different smart contracts via a façade contract facilitates the invocation and execution of composed application logic that comprises multiple smart contract functions as logic blocks. Individual calls and error handling are outsourced to the façade contract.

## Related Patterns
[Proxy Pattern](/Architectural%20Patterns/Proxy%20Pattern/README.md#context)

## Known Uses
[LATOPreICO](https://etherscan.io/address/0x459F7854776ED005B6Ec63a88F834fDAB0B6993e#code) (lines 252, 326ff), [Base and Satellite](https://github.com/maxwoe/solidity_patterns/tree/master/maintenance/satellite)
