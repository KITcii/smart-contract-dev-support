# Deactivation Pattern

## Context
The Deactivation Pattern is applicable whenever a smart contract should be removed from the distributed ledger.

``Applies to: [] EOSIO    [X] Ethereum    [] Hyperledger Fabric``
## Problem
The objective of the Deactivation Pattern is to mitigate risks associated with the removal or deactivation of smart contracts. In Ethereum, smart contracts can be removed from the distributed ledger by calling the ``self-desctruct(...)`` operation. This operation causes the remaining assets to be sent to a predefined target and both storage and code are removed from the distributed ledger. As a result, if assets are transferred to the destroyed smart contract the assets will be lost. 

## Forces
The forces involved in the Deactivation Pattern are regulated executability and semantic soundness. Executability of the smart contract is regulated as all executions of the respective smart contract are prevented. Also, semantic soundness is improved as the possible loss of assets associated with the removal of smart contracts from the distributed ledger are prevented.

## Solution
Instead of using the ``self-desctruct(...)`` operation developers should instead disable the smart contract by changing the internal state in a way that which causes all functions to revert. 

## Example
### Wrong
```Solidity 
pragma solidity 0.7.0;

contract DeactivationPattern {
    function close() public onlyOwner { 
      selfdestruct(owner); 
    }
}
```

### Correct

## Resulting Context
The application of the Deactivation Pattern ensures that the contract cannot be used while mitigating the risk associated with using the ``self-desctruct(...)`` operation to remove the smart contract. 

## Rationale
Keeping outdated smart contracts executable on the distributed ledger may result in unintended calls of the respective smart contract. The Deactivation Patterns provides a way to regulate the executability so that it is impossible to use the smart contract, as assets are immediately returned.

## Related Patterns
\-

## Known Uses
\-
