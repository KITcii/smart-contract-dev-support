# Deactivation Pattern

## Context
The Deactivation Pattern is applies when a smart contract should be removed from an Ethereum-based distributed ledger.

``Applies to: [] EOSIO    [X] Ethereum    [] Hyperledger Fabric``
## Problem
In Ethereum, smart contracts can be removed from the distributed ledger by calling the `selfdestruct(...)` operation. Calling `selfdestruct(...)` initiates the transfer of assets kept by that contract to be sent to a predefined target and both storage and code are removed from the distributed ledger. When assets are transferred to the destroyed smart contract, the assets will be lost. The aim of the Deactivation Pattern is to mitigate risks associated with the removal or deactiva-tion of smart contracts.

## Forces
The forces involved in the Deactivation Pattern are regulated executability and semantic soundness. Executability of the smart contract is regulated as all executions of the respective smart contract are prevented. Also, semantic soundness is improved as the possible loss of assets associated with the removal of smart contracts from the distributed ledger are prevented.

## Solution
Instead of using the ``selfdestruct(...)`` operation developers should instead disable the smart contract by changing the internal state in a way that which causes all functions to revert. 

## Example
### Wrong
```Solidity 
pragma solidity 0.7.0;

contract DeactivationAntipattern {
    //...
    function close() public { 
      selfdestruct(msg.sender); 
    }
}
```

### Correct
```Solidity 
pragma solidity 0.7.0;

contract DeactivationPattern {
    bool _activated = true; 
    
    modifier checkActive(){
      require (_activated);
    }
    //...
    function anyFunction() checkActive public {
      //code to be reverted by deactivation 
    }
}
```

## Resulting Context
The application of the Deactivation Pattern ensures that the contract cannot be used while mitigating the risk associated with using the ``selfdesctruct(...)`` operation to remove the smart contract. 

## Rationale
Keeping outdated smart contracts executable on the distributed ledger may result in unintended calls of the respective smart contract. The Deactivation Patterns provides a way to regulate the executability so that it is impossible to use the smart contract because assets are immediately returned.

## Related Patterns
\-

## Known Uses
\-
