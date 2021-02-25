# Factory Pattern
## Context
The Factory Pattern is applicable if an application requires multiple instances of a smart contract to be deployed to a distributed ledger.

``Applies to: [] EOSIO    [X] Ethereum    [] Hyperledger Fabric``

## Problem
The objective of the Factory Pattern is to avoid risks connected with the redeployment of similar smart contracts. The manual redeployment of similar smart contracts (e.g., smart contracts used for asset representation) from a Template Contract is inefficient because, for example, human engagement is required. In addition, users must trust that the Template Contract used to create new smart contracts is not manipulated if it is kept off-ledger. The creation of new smart contracts should be automatically and reliably managed on the distributed ledger in a transparent manner. The creation of new smart contracts should be traceable.

## Forces
The forces involved in the Factory Pattern are semantic soundness, manual effort and resource efficiency. Resource efficiency will be reduced as the automation of redeployment of similar smart contracts requires additional smart contracts that enable the automatic re-deployment. At the cost of reducing resource efficiency the implementation soundness of the deployed smart contract will be improved through preventing the possibility of off-ledger manipulation and the reduction of human engagement and manual effort.

## Solution
Instantiate two smart contracts: Factory and Template Contract. The Template Contract serves as a blueprint for smart contracts to be deployed by the Factory. The Factory has a function implemented that can be called by users to deploy a Child Contract as an instance of Template Contract. In this function, conditions can be defined, which must be met by users to let the Factory deploy a Child Contract. If a user meets these conditions, the Factory deploys a new instance of the Child Contract. Optionally, the Factory can also implement list of addresses of deployed Child Contract to better trace them.

## Example

Wrong | Correct
------------- | -------------
![Wrong](Smart-Contract-Factory%20Pattern%20-%20Manual%20Smart%20Contract%20Creation.png)  | ![Correct](Smart-Contract-Factory%20Pattern%20-%20Automated%20Smart%20Contract%20Creation%20via%20Factory.png)

## Resulting Context
Token are created and issued by a Factory Smart Contract. In the above example, we enhanced the basic Factory Pattern by an array that allows to directly retrieve the number and address of issued tokens by the Factory Smart Contract, which additionally eases to observe issued tokens.

## Rationale
By creating and issuing Child Contracts from a Factory Smart Contract, the Child Contract creation can be managed in a centralized but reliable way. As a return value for successful creation of Child Contracts, the address of the Child Contract token is returned, which can be appended to an array to keep track of issued tokens.

## Related Patterns
[Token Pattern](/Idioms/Token%20Pattern/README.md#context)

## Known Uses
[CharitySplitter](https://blog.ethereum.org/2020/01/29/solidity-0.6-try-catch/)
