# Factory Pattern
## Context
The Factory Pattern applies for applications that require multiple instances of a smart contract to be deployed to a distributed ledger.

``Applies to: [] EOSIO    [X] Ethereum    [] Hyperledger Fabric``

## Problem
The manual redeployment of smart contracts (e.g., smart contracts used for asset representation) from a Template Contract is inefficient because human engagement is required. In addition, users must trust that the Template Contract used to create new smart contracts is not manipulated if it is kept off-ledger. The aim of the Factory Pattern is to automate the deployment of smart contracts from Template Contracts in a reliable and transparent manner.

## Forces
The forces involved in the Factory Pattern are semantic soundness, manual effort, and resource efficiency. Resource efficiency will be reduced as the automation of redeployment of similar smart contracts requires additional smart contracts that enable the automatic re-deployment. At the cost of reducing resource efficiency the implementation soundness of the deployed smart contract will be improved through preventing the possibility of off-ledger manipulation and the reduction of human engagement and manual effort.

## Solution
Instantiate two smart contracts: a Factory Contract and a Template Contract. The Template Contract serves as a blueprint for smart contracts to be deployed by the Factory Contract. The Factory Contract has a function implemented that can be called by users to deploy a Child Contract as an instance of Template Contract. In this function, conditions can be defined, which must be met by users to let the Factory Contract deploy a Child Contract. If a user meets these conditions, the Factory Contract deploys a new instance of the Child Contract. Optionally, the Factory Contract can also implement list of addresses of deployed Child Contract to better trace them.

## Example

Wrong | Correct
------------- | -------------
![Wrong](Smart-Contract-Factory%20Pattern%20-%20Manual%20Smart%20Contract%20Creation.png)  | ![Correct](Smart-Contract-Factory%20Pattern%20-%20Automated%20Smart%20Contract%20Creation%20via%20Factory.png)

## Resulting Context
Child Contracts are created and issued by a Factory Contract in a automated, yet reliable and transparent manner. The identity that aims to create a Child Contract pays for the computational cost (e.g., proportional to the consumed gas in Ethereum) to deploy the smart contract.

## Rationale
By creating and issuing Child Contracts from a Factory Contract, the security guarantees of smart contract execution (e.g., reliable execution independent from third parties) are inherited to the automated creation of Child Contracts.

## Related Patterns
[Token Pattern](../../Idioms/Token%20Pattern/README.md#context)

[Observer Pattern](../../Architectural%20Patterns/Observer%20Pattern/README.md)

## Known Uses
[CharitySplitter](https://blog.ethereum.org/2020/01/29/solidity-0.6-try-catch/)
