# Deactivation Pattern

## Context
The Deactivation Pattern is applicable whenever a smart contract should be removed from the distributed ledger.

``Applies to: [] EOSIO    [X] Ethereum    [] Hyperledger Fabric``
## Problem
The objective of the Deactivation Pattern is to mitigate risks associated with the removal or deactivation of smart contracts. In Ethereum, smart contracts can be removed from the distributed ledger by calling the ``self-desctruct(...)`` operation. This operation causes the remaining assets to be sent to a predefined target and both storage and code are removed from the distributed ledger. As a result, if assets are transferred to the destroyed smart contract the assets will be lost. 

## Forces


## Solution
Instead of using the ``self-desctruct(...)`` operation developers should instead disable the smart contract by changing the internal state in a way that which causes all functions to revert. 

## Example
### Wrong

### Correct

## Resulting Context
The application of the Deactivation Pattern ensures that the contract cannot be used while mitigating the risk associated with using the ``self-desctruct(...)`` operation to remove the smart contract. 

## Rationale

## Related Patterns

## Known Uses

