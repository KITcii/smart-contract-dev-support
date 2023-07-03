# Checks-Effects-Interactions Pattern

## Context
The Checks-Effects-Interactions Pattern applies to functions of Ethereum smart contracts that make external calls.

``Applies to: [] EOSIO    [X] Ethereum    [] Hyperledger Fabric``

## Problem
External calls from smart contract functions can allow for unintended recursive calls during the execution of the external call, causing vulnerabilities to reentrancy attacks. Exploiting the possibility for recursive calls, a called smart contract can, for example, drain tokens kept by the callee contracts. The aim of the Checks-Effects-Interactions Pattern is to protect smart contracts from reentrancy.

## Forces
The main force involved in the Checks-Effects-Interactions Pattern is implementation soundness, particularly semantic soundness as the application of the Checks-Effects-Interactions Pattern prevents unintended program flow in smart contracts caused by reentrancy attacks.

## Solution
Developers must first update values of all variables used in the condition (e.g., `withdraw(...)`) before proceeding with the execution of smart contract code.
## Example
### Wrong
```Solidity 
pragma solidity 0.7.0;

// This smart contract is vulnerable to reentrancy and DoS
contract ChecksEffectsInteractionsAntipattern {
    mapping (address => uint256) public balances;
    //...
    function withdraw(uint _amount) public{
        // Checks
        if(balances[msg.sender] >= _amount){
            // Interactions
            (bool success,) = msg.sender.call{value: _amount}("");
            require(success);
            // Effects
            balances[msg.sender] -= _amount;
        }
    }
}
```
### Correct
```Solidity 
pragma solidity 0.7.0;

contract ChecksEffectsInteractionsPattern {
    mapping (address => uint256) public balances;
    //...
    function withdraw(uint _amount) public{
        // Checks
        if(balances[msg.sender] >= _amount){
            // Effects
            balances[msg.sender] -= _amount;
            // Interaction
            (bool success,) = msg.sender.call{value: _amount}("");
            require(success);
        }
    }
}

```
## Resulting Context
The Checks-Effects-Interactions Pattern prevents reentrancy because all values of variables relevant to a condition have been updated when the condition applies.

## Rationale
In the execution of Ethereum smart contracts, each instruction is put on the call stack of the Ethereum Virtual Machine (EVM) and needs to be processed before the smart contract terminates and the state transitions conclude. Unintended program flows are caused when instructions are not processed in the intended order. In a smart contract A, for example, a condition *c* checks if the balance associated with an address is sufficient for a token transfer and aborts the asset transfer if that balance is not sufficient. All associated instructions are put on the stack of the EVM. After successfully passing *c*, A first transfers tokens to an address and subsequently updates the balance of the target address in a local data structure. The target address corresponds to a smart contract B. Upon receiving the tokens from A, B recursively calls the callee function in A. All instructions associated with the function execution of B are put on the call stack. These new instructions are first executed before the execution of the original function is continued. Because the balance associated with B's address is updated after the token transfer, *c* does not abort recursive calls from B and can be executed arbitrarily often. This way, for example, B can drain the tokens kept by A.

To prevent reentrancy, variables used in conditions (like *c*) should be updated prior to external calls.

## Related Patterns
[External-Call](../../Idioms/External-Call%20Pattern/README.md), [Mutex Pattern](../../Design%20Patterns/Mutex%20Pattern/README.md), [Pull Pattern](../../Design%20Patterns/Pull%20Pattern/README.md)
## Known Uses
[ItemRegistry](https://etherscan.io/address/0x17df117bb806a622d841bd5166a23b5d8746232f/#code) (lines 181ff), [Simple Open Auction](https://github.com/vyperlang/vyper/blob/v0.2.11/examples/auctions/simple_open_auction.vy) (lines 75ff)
