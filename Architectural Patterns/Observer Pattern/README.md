# Observer Pattern
## Context
The Observer pattern is applicable to Ethereum smart contracts that are invoked by other contracts and updated by redeployment in the future. When a smart contract is deployed in an updated version, the contract has a new address. All calling contracts must update the address to reference the latest version of the smart contract.

``Applies to: [] EOSIO    [X] Ethereum    [] Hyperledger Fabric``

## Problem
The objective of the Observer Pattern is to simplify and automate the address update of Target Contracts efficiently after the Target Contract's redeployment. In this context, efficiency refers to both time and cost (e.g., gas cost in Ethereum). Moreover, new Caller Contracts should be easy to add and remove from the update procedure. The problem related to the address update of Target Contracts arises as the address of the Target Contract changes over time due to maintenance and the associated redeployment of the Target Contract. The Caller Contracts must then update the address of the Target Contract to interact with its latest version. The developers of the Caller Contracts may not be known and, thus, cannot be immediately informed about the update. 

## Forces
The forces involved in the Observer Pattern are maintainability particulary code updatability, semantic soundness and resource efficiency. The application of the Observer Pattern improves code updatability of the Target Contracts as the address of the redeployed Target Contract is communicated to the Caller Contracts. Thus, improving semantic soundness of the Caller Contracts as calls to deprecated or destroyed smart contracts and the risks associated with them are prevented. At the same time this comes at the cost of resource efficiency as an Observer Contract needs to be deployed as part of the Observer Pattern.

## Solution
Implement an Observer Contract and subscribe all Caller Contracts to the Observer Pattern using their addresses. Whenever a Target Contract was updated, the responsible developer should call the Observer Contract’s update function associated with the updated Target Contract and pass the address of the newly deployed Target Contract. Next, the Observer Contract iterates over all Caller Contract addresses that are subscribed to receive the new address of the updated Target Contract and executes the individual Caller Contracts’ update functions. The individual update functions of the Caller Contracts should comply with a standardized interface to facilitate the update procedure of the Observer Contract. Observer Contracts can implement individual update functions for various Target Contracts.

To avoid undesired or even malicious updates of smart contract addresses, the Observer Contract and the individual Caller Contracts must implement authorization checks to restrict the execution of the individual update functions. Therefore, the owner of the Caller Contracts should be authorized to set the address of the Observer Contract at the Caller Contracts.

## Example
![Observer](Observer%20Pattern%20-%20Observer.png)

## Resulting Context
Developers of the software project can easily notify all Caller Contracts about the new version of the Target Contract. However, in distributed ledgers like Ethereum, these developers must pay for the update. Therefore, the Observer Pattern is foremost suitable to update their own smart contracts instead of arbitrary smart contracts of also foreign developers.

## Rationale
The Observer Contract iterates over the set of Caller Contracts that are subscribed to address updates related to a certain Target Contract and executes the individual Caller Contract’s update function. The update functions of all Caller Contracts offer a uniform interface to facilitate the update procedure.

## Related Patterns
\-

## Known Uses
\-
