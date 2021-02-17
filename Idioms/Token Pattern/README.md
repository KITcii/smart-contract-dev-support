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
pragma solidity ^0.7.0;

contract TokenAntipattern {
    address public minter;
    
    mapping (address => uint256) public balances;
    uint256 highest_bid = 0;
    address highest_bidder;

    event Sent(address from, address to, uint amount);

    constructor() public {
        minter = msg.sender;
    }

    function mint(address receiver, uint amount) public returns(uint256) {
        require(msg.sender == minter);
        
        balances[receiver] += amount;
        return balances[receiver];
    }

    function send(address receiver, uint amount) public returns(bool) {
        require(amount <= balances[msg.sender], "Insufficient balance.");
        
        balances[msg.sender] -= amount;
        balances[receiver] += amount;
        emit Sent(msg.sender, receiver, amount);
        return true;
    }

    function auction(uint256 bid) public {
        require(balances[msg.sender] >= bid, "Insufficient balance.");
        require(bid>highest_bid, "Your bid is too low.");
        
        highest_bidder = msg.sender;
        highest_bid = bid;
    }
}

```
### Correct
```Solidity 
pragma solidity ^0.7.0;

contract TokenPattern {
    address public minter;
    mapping (address => uint) public userBalances;
    event Sent(address from, address to, uint amount);

    constructor() public {
        minter = msg.sender;
    }

    function mint(address receiver, uint amount) public returns(uint256) {
        // Equals function mint(…) of the wrong example lines 17-20
    }

    function send(address receiver, uint amount) public returns(bool) {
        // Equals function send(…) of the wrong example lines 24-29
    }
}

contract LogicContract {
    address owner;
    TokenContract t;
    address public highest_bidder;
    uint256 highest_bid;

    constructor() public {
        owner = msg.sender;
    }
    
    function changeToken (address _address) public {
        require(msg.sender == owner);
        t = TokenContract(_address);
    }

    function auction(uint256 bid) public {
        require(t.userBalances(msg.sender) >= bid, "Insufficient balance.");
        require(bid>highest_bid, "Your bid is too low.");
        
        highest_bidder = msg.sender;
        highest_bid = bid;
    }
```
_Note:_ Due to space constraints we did not use modifiers in the examples. Please better use modifiers for authorization checks to improve comprehensibility of the code. In addition, the code example does only illustrate the separation from logic and the token management. The LogicContract implements no mechanisms to lock assets so that the bidders cannot spend their assets for after their bidding and may become unable to pay.

## Resulting Context
Developers can maintain logic expressed in smart contract code to manage data or assets without the risk of losing them. The data are always kept by the same smart contract. To prevent single users from acquiring lots of tokens in an early stage of the sale, an Anti-Early-Whale mechanism should be implemented (e.g., a timer for assets distribution and a pause mechanism to temporarily stop assets).

## Rationale
A new smart contract that manages the tokens (e.g., token transfers) can be deployed to the distributed ledger and access the Token Contract according to the Token Contract’s authorization scheme. By doing so, not fees for token transfers from the Token Contract to another have to be paid during an update and maintenance-related functionality for such transfers does not have to be implemented.

## Related Patterns
[Façade Pattern](../../Architectural%20Patterns/Façade%20Pattern/README.md), [Proxy Pattern](../../Architectural%20Patterns/Proxy%20Pattern/README.md)

## Known Uses
[LATOPreICO](https://etherscan.io/address/0xDa2Cf810c5718135247628689D84F94c61B41d6A#code) (lines 252, 326ff)
