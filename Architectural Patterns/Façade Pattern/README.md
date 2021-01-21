# Context
Developers should divide the application logic into different modules to achieve a precise separation of concerns and better maintainability. Such modules are implemented as separate smart contracts, whose functions must be called individually.
# Problem
The manual but secure interaction with multiple (potentially interacting) smart contracts to execute a specific, superordinate application logic is a chal-lenge because various side-effects, interdependencies, and potentially resulting vulnerabilities must be considered. This interaction becomes even more difficult when certain smart contracts are re-used because of maintenance and their addresses change
# Forces
The interaction with several smart contracts should be easy for distributed ledger technology (DLT) application developers, also during maintenance and changing associated smart contract addresses. It should not be the DLT application developers’ task to individually handle challenges regarding the inter-action of smart contracts on the client side of their application. It should be possible to (at least) partially revert failed function executions in smart contracts.
# Solution
There are two roles of smart contracts: multiple Satellites and one Façade Contract. Satellites are smart contracts that represent a module of the appli-cation logic and the Façade Contract serves as a proxy to interact with the Satellites and execute a sequence of function calls with only one call to the Façade Contract. Therefore, each Satellite’s address is registered with the Façade Contract. To execute a certain logic expressed in a sequence of smart contract calls, the Façade Contract loads the instance(s) of the required Satellites using the registered smart contract addresses and calls targeted func-tions in a certain order. All interactions and potential errors are handled by the Façade Contract.
# Example
Wrong | Correct
------------- | -------------
Content Cell 1  | Content Cell 2

# Resulting Context

# Rationale

# Related Patterns

# Exemplary Uses
