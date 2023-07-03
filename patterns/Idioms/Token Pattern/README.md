# Token Pattern
## Context
The Token Pattern can be applied when creating smart contracts that keep tokens or handle data related to accounts' balances.

``Applies to: [] EOSIO    [X] Ethereum    [] Hyperledger Fabric``
## Problem
Smart contracts that manage and store assets are hard to maintain because updated logic for asset management must be deployed in a new version of the contract, and assets must be transferred to that new contract in order to it to keep the state of the deprecated contract. The aim of the Token Pattern is to enable code updates for smart contracts that manage and keep tokens, thus improving maintainability of those smart contracts. At the same time, the risks (e.g., asset loss due to locking a smart contract or transferring stored assets to a wrong smart contract) and costs that are usually connected with the update of smart contracts keeping tokens (e.g., transferring all balances to an updated version of the smart contract) should be avoided. 

## Forces
The forces involved in the Token Pattern are maintainability, particularly code updatability, and code efficiency, particularly the number and way of required interactions. The application of the Token Pattern improves maintainability by enabling updates of smart contract logic without the risks and costs associated with the update of smart contracts keeping tokens. At the same time, increased maintainability comes at the cost of code efficiency as the number of required interactions between can smart contracts
increase.

## Solution
Logic and data in smart contracts should be separated into `LogicContract` and `TokenContract`. `TokenContract` provides data on the liquidity of accounts and keeps the tokens. If code functionality needs to be changed, only the `LogicContract` is updated. `TokenContract` can remain unchanged. When a new version of the `LogicContract` is deployed, the deprecated `LogicContract` must be destroyed.

## Example

### Wrong
```Solidity 
pragma solidity 0.7.0;

contract TokenAntipattern {
        //...
    function mint(address receiver, uint amount) public returns(uint256) {
        //...
    }

    function send(address receiver, uint amount) public returns(bool) {
        //...
    }

    function auction(uint256 bid) public {
        //...
    }
}

```
### Correct
```Solidity 
pragma solidity 0.7.0;

contract TokenContract {
    //...
    
    function mint(address receiver, uint amount) public returns(uint256) {
        // Equals function mint(…) of the wrong example lines 17-20
    }

    function send(address receiver, uint amount) public returns(bool) {
        // Equals function send(…) of the wrong example lines 24-29
    }
}

contract LogicContract {
    //...
    function changeTokenContract (address _address) public {
        //...
    }

    function auction(uint256 bid) public {
        //...
    }
}
```

## Resulting Context
Developers can maintain logic expressed in smart contract code to manage data or assets without the risk of losing them. The data are always kept by the same smart contract. 

## Rationale
A new smart contract that manages the tokens (e.g., token transfers) can be deployed to the distributed ledger and access `TokenContract` according to its authorization scheme. By doing so, no fees for token transfers from the `TokenContract` to another must be paid during an update, and maintenance-related functionality for such transfers does not have to be implemented.

## Related Patterns
[Factory Pattern](../../Design%20Patterns/Factory%20Pattern/README.md)

## Known Uses
[LATOPreICO](https://etherscan.io/address/0xDa2Cf810c5718135247628689D84F94c61B41d6A#code) (lines 252, 326ff)
