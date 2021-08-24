# Observer Pattern
## Context
The Observer Pattern applies to smart contracts on Ethereum-based blockchains that are invoked by other smart contracts and are likely to be replaced with another smart contract on another address, deactivated, or destroyed in the future.

``Applies to: [] EOSIO    [X] Ethereum    [] Hyperledger Fabric``

## Problem
To update Ethereum-based smart contracts, a new smart contract must be deployed that has a new address. In systems comprising multiple smart contracts, all smart contracts (i.e., Caller Contracts) interacting with specific contracts (i.e., Target Contracts) must have the address of the current version of the Target Contract to prevent vulnerabilities and inconsistencies across contracts in the smart contract system. After deploying an updated Target Contract, the address of the Target Contract stored by the Caller Contract must be replaced with the current address. However, the developers of the Caller Contracts may not be known and, thus, cannot be immediately informed about the update. Moreover, individually updating each Caller Contract in a manual way is time consuming and represents a potential source of error (e.g., by sending a wrong address or forgetting to update a Caller Contract). The aim of the Observer Pattern is to facilitate address updates in Caller Contracts through automation.

## Forces
The forces involved in the Observer Pattern are maintainability, particularly code updatability, semantic soundness and resource efficiency. The application of the Observer Pattern improves code updatability of the Target Contracts as the address of the redeployed Target Contract is communicated to the Caller Contracts. Thus, improving semantic soundness of the Caller Contracts as calls to deprecated or destroyed smart contracts and the risks associated with them are prevented. At the same time, this comes at the cost of resource efficiency as an Observer Contract needs to be deployed as part of the Observer Pattern.

## Solution
Implement an Observer Contract and subscribe all Caller Contracts to the Observer Pattern using their addresses. Whenever a Target Contract was updated, the responsible developer should call the Observer Contract’s update function associated with the updated Target Contract and pass the address of the newly deployed Target Contract. Next, the Observer Contract iterates over all Caller Contract addresses that are subscribed to receive the new address of the updated Target Contract and executes the individual Caller Contracts’ update functions. The individual update functions of the Caller Contracts must comply with a standardized interface to facilitate the update procedure of the Observer Contract. Observer Contracts can implement individual update functions for various Target Contracts.
To avoid undesired or even malicious updates of smart contract addresses, the Observer Contract and the individual Caller Contracts implement authorization checks to restrict the execution of the individual update functions. The owner of the Caller Contracts must be authorized to change the address of the Observer Contract in the Caller Contracts.

## Example
![Observer](Observer%20Pattern%20-%20Observer.png)

## Resulting Context
Developers of the software project can notify all Caller Contracts about the new version of the Target Contract by calling the Observer Contract. However, in distributed ledgers like Ethereum, these developers must pay for the update. Therefore, the Observer Pattern is foremost suitable to update their own smart contracts instead of arbitrary smart contracts of also foreign developers.

## Rationale
The Observer Contract iterates over the set of Caller Contracts that are subscribed to receive updated addresses of a specific Target Contract and executes the individual Caller Contract’s update function. The update functions of all Caller Contracts offer a uniform interface to facilitate the update procedure.

## Related Patterns
\-

## Known Uses
\-
