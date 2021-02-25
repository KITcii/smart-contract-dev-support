# Mutex Pattern

## Context
The Mutex Pattern can be applied to prevent reentrancy attacks when a smart contract is interacting with other smart contracts. For instance, recursive calls of a smart contract function before its termination (i.e., reentrancy) can occur if a smart contract function allows (external) function calls in an inconsistent state. Such an inconsistent state is characterized by contradicting variable values. For instance, an account’s balance may be recorded in a mapping and be updated after a transfer of assets. In the time between the assets have been sent and the balance is updated in the mapping, the smart contract is in an inconsistent state.

There are three types of reentrancy and the Mutex Pattern applies to all of them. First, in _cross-function reentrancy_, a smart contract function is invoked and reentered through another function, while the smart contract is still in an inconsistent state. Second, _delegated reentrancy_ occurs when a smart contract imports other smart contracts (e.g., as a smart contract library) and makes delegate calls to function of the imported smart contract, while state-updates of these smart contracts are not synchronized appropriately. Third, _create-based reentrancy_ can occur if one smart contract calls the constructor of another smart contract and updates its state afterwards. The constructor can invoke external functions such as the original smart contract and, thus, reenter the original function.

## Problem
The objective of the Mutex Pattern is to prevent reentrancy attacks as unintended reentrancy can allow for theft of assets managed by the smart contract. The intended program flow of the smart contract should be assured. Especially, the smart contract functions should be protected from unintended side effects of, for example, calls-to-the-unknown and resulting reentrancy.

## Forces
The forces involved in the Mutex Pattern are semantic soundness and code efficiency. Semantic soundness is improved by the Mutex Pattern through preventing unintended program flow caused by reentrancy attacks. The implementation of the Mutex Pattern comes at the cost of code efficiency as additional smart contract code needs to be implemented.

## Solution
Implement a mutex variable that prevents concurrent access to a variable and to protect critical parts of smart contract code, in which inconsistencies may occur (e.g., updating the balance of an account before sending those assets to the account). The mutex variable is a variable used in a condition that must validate as true to execute subsequent smart contract code. Otherwise, the code protected by the mutex variable is not executed. After the execution of the protected smart contract code, the mutex is unlocked to allow for the next execution of the protected code. To protect a whole smart contract from reentrancy, such mutexes should be used in all of its functions.

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
        bool success, ) = msg.sender.call{value: _amount}("");
        require(success);

        return true;
    }
}

```
## Resulting Context
All state modifications are carried out if the flag is set true. Otherwise, function invocations are prevented if they are out of the intended order. There-fore, a reentrancy attack invoking recursive calls that exploit the inconsistent state of a smart contract can be prevented. The smart contract execution can become slightly costlier (e.g., in terms of gas) because of additional conditions to be considered using mutex variables.
## Rationale
By implementing the Mutex Pattern, a smart contract function cannot be executed if the function execution enters a certain point protected by a mutex variable until the function execution passed another point, where the mutex variable is unlocked again. In case an attacker aims to reenter the smart contract function, the execution will be aborted. By doing so, the smart contract function is protected from reentrancy.

## Related Patterns
[Checks-Effects-Interactions Pattern](/Idioms/Checks-Effects-Interactions%20Pattern/README.md#context), [Event-Order Pattern](/Design%20Patterns/Event-Order%20Pattern/README.md#context), [External-Call Pattern](/Idioms/External-Call%20Pattern/README.md#context)

## Known Uses
[CrowdsourceMinter](https://etherscan.io/address/0xDa2Cf810c5718135247628689D84F94c61B41d6A#code) (lines 60ff), [VentanaToken](https://etherscan.io/address/0x30CefBcb5C26A5B19a019092Ab8d09F8739c904F#code) (lines 115ff)
