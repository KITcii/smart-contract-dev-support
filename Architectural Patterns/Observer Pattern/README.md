# Architectural Patterns
## Context
Within a software project, smart contracts (Caller Contracts) invoke functions from another smart contract (Target Contract). The address of the Target Contract changes over time due to maintenance and the associated redeployment of the Target Contract.

``Applies to: [X] EOSIO    [X] Ethereum    [] Hyperledger Fabric``
## Problem
Caller Contracts must update the address of the Target Contract to interact with its latest version. The developers of the Caller Contracts may not be known and, thus, cannot be immediately informed about the update.

## Forces
Developers should efficiently update all Caller Contracts that make use of the Target Contract after the Target Contract's redeplyment. In this context, efficiency refers to both time and cost (e.g., gas cost in Ethereum). Moreover, new Caller Contracts should be easy to add and remove from the update procedure.

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
