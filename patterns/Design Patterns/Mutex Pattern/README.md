# Mutex Pattern

## Context
The Mutex Pattern can be applied to secure external calls from Ethereum smart contracts.

``Applies to: [] EOSIO    [X] Ethereum    [] Hyperledger Fabric``

## Problem
External calls from smart contract functions can allow for unintended recursive calls during the execution of the external call, causing vulnerabilities to reentrancy attacks. Exploiting the possibility for recursive calls, a called smart contract can, for example, drain tokens kept by the callee contracts. The aim of the Mutex Pattern is to prevent reentrancy attacks.

## Forces
The forces involved in the Mutex Pattern are semantic soundness and code efficiency. Semantic soundness is improved by the Mutex Pattern through preventing unintended program flow caused by reentrancy attacks. The implementation of the Mutex Pattern comes at the cost of code efficiency as additional smart contract code needs to be implemented.

## Solution
Implement a mutex variable to protect critical parts of smart contract code from repeated execution through external calls. The mutex variable is a variable used in a condition that must validate as true to execute subsequent smart contract code. Otherwise, the code protected by the mutex variable is not executed. After the execution of the protected smart contract code, the mutex is unlocked to allow for the next execution of the protected code. To protect a whole smart contract from reentrancy, such mutexes should be used in all its functions including external calls.

## Example
### Wrong
```Solidity 
pragma solidity ^0.7.0;

contract MutexAntipattern {
    mapping(address => uint256) public balances;
    //...
    function withdraw(uint _amount) external {
        require(balances[msg.sender] >= _amount, "No balance to withdraw.");
        
        balances[msg.sender] -= _amount;
        msg.sender.call{value: _amount}("");
    }
}

```
### Correct
```Solidity 
pragma solidity ^0.7.0;

contract MutexPattern {
    bool locked = false;
    mapping(address => uint256) public balances;
    
    modifier noReentrancy() {
        require(!locked, "Blocked from reentrancy.");
        locked = true;
        _;
        locked = false;
    }
    //...
    function withdraw(uint _amount) public payable noReentrancy returns(bool) {
        require(balances[msg.sender] >= _amount, "No balance to withdraw.");
        
        balances[msg.sender] -= _amount;
        bool (success, ) = msg.sender.call{value: _amount}("");
        require(success);

        return true;
    }
}

```
## Resulting Context
All state modifications are carried out if the flag is set `true`. Otherwise, function invocations are prevented if they are out of the intended order. Therefore, unintended recursive calls to smart contract functions can be prevented. The smart contract execution can become slightly costlier (e.g., in terms of gas) because of additional conditions to be considered using mutex variables.

## Rationale
In the execution of Ethereum smart contracts, each instruction is put on the call stack of the Ethereum Virtual Machine (EVM) and needs to be pro-cessed before the smart contract terminates and the state transitions conclude. Unintended program flows are caused when instructions are not pro-cessed in the intended order. In a smart contract A, for example, a condition *c* checks if the balance associated with an address is sufficient for a token transfer and aborts the asset transfer if that balance is not sufficient. All associated instructions are put on the stack of the EVM. After successfully passing *c*, A first transfers tokens to an address and subsequently updates the balance of the target address in a local data structure. The target ad-dress corresponds to a smart contract B. Upon receiving the tokens from A, B recursively calls the callee function in A. All instructions associated with the function execution of B are put on the call stack. These new instructions are first executed before the execution of the original function is be continued. Because the balance associated with B's address is updated after the token transfer, *c* does not abort recursive calls from B and can is executed arbitrarily often. This way, for example, B can drain the tokens kept by A.

By implementing the Mutex Pattern, a smart contract function cannot be executed if the function execution enters a certain point protected by a mutex variable until the function execution passed another point, where the mutex variable is unlocked again. When an attacker reenters the smart contract function, the execution is aborted, and the smart contract function is protected from reentrancy.

## Related Patterns
[Checks-Effects-Interactions Pattern](/Idioms/Checks-Effects-Interactions%20Pattern/README.md#context), [Event-Order Pattern](/Design%20Patterns/Event-Order%20Pattern/README.md#context), [External-Call Pattern](/Idioms/External-Call%20Pattern/README.md#context)

## Known Uses
[CrowdsourceMinter](https://etherscan.io/address/0xDa2Cf810c5718135247628689D84F94c61B41d6A#code) (lines 60ff), [VentanaToken](https://etherscan.io/address/0x30CefBcb5C26A5B19a019092Ab8d09F8739c904F#code) (lines 115ff)
