# Façade Pattern
## Context
Multiple smart contracts have been deployed, each offering individual functions and logic to be executed (e.g., in favor of separation of concerns). Interactions with multiple smart contracts are required to execute an application logic composed of the different logic blocks offered by the smart contracts. The Façade Pattern can be used to facilitate complex interactions between multiple smart contracts by offering a unified entry point.

``Applies to: [X] EOSIO    [X] Ethereum    [] Hyperledger Fabric``

## Problem
Manually orchestrating the connection of the individual logic blocks of this smart contract into a composed logic thus requires multiple invocations of smart contracts. However, manually performing these calls to provision a composed application logic is prone to errors and flaws (e.g., due to misspellings or neglected side effects across smart contracts). In Ethereum-based blockchains, interacting with smart contract systems becomes even more challenging when updated smart contracts are redeployed because their addresses change. The addresses need to be updated in all systems that make calls to the outdated contract. The goal of the facade pattern is to simplify and make more secure interactions with a smart contract system, to implement logic that is composed of functions from different smart contracts, and to make it easier to maintain smart contracts.

## Forces
The forces involved in the Façade Pattern are maintainability, manual effort, and resource efficiency. Maintainability is improved by offering a unified entry point through the Façade Contract while simultaneously reducing manual effort through automation. The application of the Façade Pattern comes at the cost of resource efficiency through the deployment of an additional smart contract, the Façade Contract.

## Solution
Implement a Façade Contract that serves as an entry point for the execution of application logic composed of multiple Satellites. Satellites are smart contracts that represent a module in the contract system and implement specific logic blocks. Each Satellite address is registered with the Façade Contract. In the Façade Contract, functions are defined that execute logic composed of a sequence of calls to functions of registered Satellites. Aside from the definition of composed logic, the Façade Contract also implements checks and error handling. To execute composed logic, systems can simply call the corresponding function in the Façade Contract. Upon a function call, the Façade Contract loads the instances of the required Satellites using their registered addresses and calls targeted functions in the specified order. To prevent undesired updates of smart contract addresses in the Façade Contract, developers of the Façade Contract must implement an appropriate authorization concept.

## Example
Wrong | Correct
------------ | -------------
![Wrong](Façade%20Pattern%20-%20Direct%20Calls%20without%20Façade.png) | ![Correct](Façade%20Pattern%20-%20Direct%20via%20Façade.png)

## Resulting Context
The Façade Contract offers an entry point for the execution of application logic composed of multiple logic blocks provided by the function of Satellites and, thus, eases the execution of composed application logic. By using individual logic blocks in different Satellites, a high degree of separation of concerns can be achieved, and the maintainability of individual logic blocks is improved. Moreover, error handling can be managed in a uniform way and must not be individually implemented in each system using composed smart contract logic. However, the deployment of a Façade Contract causes additional costs in distributed ledgers like EOS or Ethereum.

## Rationale
Orchestrating different smart contracts via a Façade Contract facilitates the invocation
and execution of composed application logic that comprises multiple smart contract
functions as logic blocks. Individual calls and error handling are outsourced to the
Façade Contract.

## Related Patterns
[Proxy Pattern](/Architectural%20Patterns/Proxy%20Pattern/README.md#context)

## Known Uses
[LATOPreICO](https://etherscan.io/address/0x459F7854776ED005B6Ec63a88F834fDAB0B6993e#code) (lines 252, 326ff), [Base and Satellite](https://github.com/maxwoe/solidity_patterns/tree/master/maintenance/satellite)
