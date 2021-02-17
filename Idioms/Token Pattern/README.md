# Token Pattern
## Context
Tamper-resistance of distributed ledgers impedes maintenance of smart contracts, which is critical, if flawed smart contracts manage assets. To replace the old smart contract with a new one, data (e.g., user balances) kept by the old smart contract must be transferred to the new one, which can cause serious security issues and even loss of assets.

## Problem
It is costly and risky to update smart contracts that keep tokens and/or data related to users’ balances.

## Forces
The smart contract should be easy to maintain with low risk and low cost.

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
Developers can maintain logic expressed in smart contract code to manage data or assets without the risk of losing them. The data are always kept by the same smart contract. To prevent single users from acquiring lots of tokens in an early stage of the sale, an Anti-Early-Whale mechanism should be implemented (e.g., a timer for assets distribution and a pause mechanism to temporarily stop assets).

## Rationale
A new smart contract that manages the tokens (e.g., token transfers) can be deployed to the distributed ledger and access the Token Contract according to the Token Contract’s authorization scheme. By doing so, not fees for token transfers from the Token Contract to another have to be paid during an update and maintenance-related functionality for such transfers does not have to be implemented.

## Related Patterns
\-

## Known Uses
[LATOPreICO](https://etherscan.io/address/0xDa2Cf810c5718135247628689D84F94c61B41d6A#code) (lines 252, 326ff)
