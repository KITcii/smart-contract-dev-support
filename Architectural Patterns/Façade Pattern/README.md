# Context
Developers should divide the application logic into different modules to achieve a precise separation of concerns and better maintainability. Such modules are implemented as separate smart contracts, whose functions must be called individually.
# Problem
The manual but secure interaction with multiple (potentially interacting) smart contracts to execute a specific, superordinate application logic is a challenge because various side effects, interdependencies, and potentially resulting vulnerabilities must be considered. This interaction becomes even more difficult when certain smart contracts are reused because of maintenance and their addresses change.
# Forces
The interaction with several smart contracts should be easy for developers, also during maintenance and changing associated smart contract addresses. It should not be the DLT application developers’ task to individually handle challenges regarding the interaction of smart contracts on the client side of their application. It should be possible to (at least) partially revert failed function executions in smart contracts.
# Solution
There are two roles of smart contracts: multiple Satellites and one Façade Contract. Satellites are smart contracts that represent a module of the application logic and the Façade Contract serves as a proxy to interact with the Satellites and execute a sequence of function calls with only one call to the Façade Contract. Therefore, each Satellite’s address is registered with the Façade Contract. To execute a certain logic expressed in a sequence of smart contract calls, the Façade Contract loads the instance(s) of the required Satellites using the registered smart contract addresses and calls targeted func-tions in a certain order. All interactions and potential errors are handled by the Façade Contract.
# Example
Wrong | Correct
------------ | -------------
![Wrong](Façade%20Pattern%20-%20Direct%20Calls%20without%20Façade.png) | ![Correct](Façade%20Pattern%20-%20Direct%20via%20Façade.png)

# Resulting Context
Using a central Façade Contract offers a single access point for the execution of an application logic composed of the logic implemented in different Satellites and, thus, eases the execution of such composed application logic. Because of the use of different Satellites implementing logic for specific subtasks, developers can use those Satellites in several Façade Contracts. In addition, the Façade Contract allows to update individual Satellites by registering a novel address as long as the interfaces of the individual satellites comply with those of the original Satellites. However, the updates of smart contracts deteriorate transparency because users should first check if the used Satellites in the execution of a Façade Contract function still fulfill the intended tasks. Hence, users must trust the developers of the Satellites and the Façade Contract. Developers of the Façade Contract must implement an appropriate authorization concept to update Satellite addresses.
# Rationale
The orchestration of different smart contracts via a Façade Contract serving as a proxy eases the execution of multiple, interdependent smart contracts. All individual calls and error handling are outsourced to the Façade Contract.
# Related Patterns
* [Name-Service Pattern](/Architectural%20Patterns/Name-Service%20Pattern/README.md#context)
* [Proxy Pattern](/Architectural%20Patterns/Proxy%20Pattern/README.md#context)
# Known Uses
* [LATOPreICO](https://etherscan.io/address/0x459F7854776ED005B6Ec63a88F834fDAB0B6993e#code) (lines 252, 326ff) 
* [Base and Satellite](https://github.com/maxwoe/solidity_patterns/tree/master/maintenance/satellite)
