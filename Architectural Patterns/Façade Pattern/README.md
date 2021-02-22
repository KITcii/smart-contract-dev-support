# Façade Pattern
## Context
To achieve separation of concerns and better maintainability, developers have divided an application logic into different modules. These modules are implemented as separate smart contracts with individual addresses, forming a smart contract system. To use the entire application logic, functions of the individual smart contracts  must be called manually.

``Applies to: [X] EOSIO    [X] Ethereum    [] Hyperledger Fabric``
## Problem
Securely interacting with a smart contract system to execute an application logic is challenging due to dependencies between individual smart contracts in the system and potential side effects or vulnerabilities. Interaction with the smart contract system becomes even more challenging when certain smart contracts are redeployed due to maintenance and their address changes. Users of the smart contract system must manually orchestrate interaction with individual smart contracts in the system. Manually orchestrating interaction with a smart contract system is prone to errors and defects and can even lead to a temporary denial of service (e.g., when a destructed smart contract is invoked).
## Forces
The interaction with several smart contracts should be easy for developers, also during maintenance and when changing associated smart contract addresses. It should not be the DLT application developers’ task to individually handle challenges regarding the interaction of smart contracts on the client side of their application. It should be possible to (at least partially) revert failed function executions in smart contracts.
## Solution
There are two roles smart contracts can take: Satellite or Façade Contract. Satellites are smart contracts that represent a module in the smart contract system. The Façade Contract serves as an entry point to interact with the Satellites. Each Satellite’s address is registered with the Façade Contract. With only one call to the Façade Contract, a sequence of calls to functions of the individual Satellites can be executed. To execute a certain logic expressed in a sequence of smart contract calls, the Façade Contract loads the instance(s) of the required Satellites using the registered smart contract addresses and calls targeted functions in a defined order. All interactions with Satellites and potential errors are handled by the Façade Contract.
## Example
Wrong | Correct
------------ | -------------
![Wrong](Façade%20Pattern%20-%20Direct%20Calls%20without%20Façade.png) | ![Correct](Façade%20Pattern%20-%20Direct%20via%20Façade.png)

## Resulting Context
Using a Façade Contract offers a single entry point for the execution of an application logic composed of the logic implemented in different Satellites and, thus, eases the execution of such composed application logic. Because of the use of different Satellites implementing logic for specific subtasks, developers can use those Satellites in several Façade Contracts. In addition, the Façade Contract allows to update individual Satellites by registering a novel address as long as the interfaces of the individual satellites comply with those of the original Satellites. However, the updates of smart contracts deteriorate transparency because users should first check if the used Satellites in the execution of a Façade Contract function still fulfill the intended tasks. Hence, users must trust the developers of the Satellites and the Façade Contract. Developers of the Façade Contract must implement an appropriate authorization concept to update Satellite addresses.
## Rationale
The orchestration of different smart contracts via a Façade Contract serving as a proxy eases the execution of multiple, interdependent smart contracts. All individual calls and error handling are outsourced to the Façade Contract.
## Related Patterns
[Proxy Pattern](/Architectural%20Patterns/Proxy%20Pattern/README.md#context)
## Known Uses
[LATOPreICO](https://etherscan.io/address/0x459F7854776ED005B6Ec63a88F834fDAB0B6993e#code) (lines 252, 326ff), [Base and Satellite](https://github.com/maxwoe/solidity_patterns/tree/master/maintenance/satellite)
