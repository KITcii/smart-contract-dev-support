# Token Pattern
## Context
The Token Pattern can be applied when creating smart contracts that keep tokens or handle data related to accounts' balances.

``Applies to: [] EOSIO    [X] Ethereum    [] Hyperledger Fabric``
## Problem
The objective of the Token Pattern is to enable updates to the logic of smart contracts that keep tokens and, thus, enabling maintainability of those smart contracts. At the same time the risks and costs usually connected with the update of smart contracts that keep tokens should be avoided. These include the payment of fees related with token transfer to a new updated smart contract or the risk of losing assets or data related to users' balances. 

## Forces
The forces involved in the Token Pattern are maintainability of smart contracts on the one hand and comprehensibility and readibility on the other hand. The application of the Token Pattern improves maintainability by enabling an update of the logic of the smart contract without the risks and costs associated with the update of a smart contract keeping tokens. At the same time this comes at the cost of comprehensibility and readibility of the contract as the code is spread out over seperate contracts.

## Solution
Logic and data in smart contracts should be separated into a Logic Contract and a Token Contract. The Token Contract provides data on the liquidity of accounts and keeps the tokens. If code functionality needs to be changed, only the Logic Contract is updated. The Token Contract can remain unchanged. When a new version of the Logic Contract is deployed, the deprecated Logic Contract must be destroyed.

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

contract TokenPattern {
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
    function changeToken (address _address) public {
        //...
    }

    function auction(uint256 bid) public {
        //...
    }
```

## Resulting Context
Developers can maintain logic expressed in smart contract code to manage data or assets without the risk of losing them. The data are always kept by the same smart contract. 

## Rationale
A new smart contract that manages the tokens (e.g., token transfers) can be deployed to the distributed ledger and access the Token Contract according to the Token Contract’s authorization scheme. By doing so, no fees for token transfers from the Token Contract to another have to be paid during an update and maintenance-related functionality for such transfers does not have to be implemented.

## Related Patterns
[Factory Pattern](../../Design%20Patterns/Factory%20Pattern/README.md)

## Known Uses
[LATOPreICO](https://etherscan.io/address/0xDa2Cf810c5718135247628689D84F94c61B41d6A#code) (lines 252, 326ff)
