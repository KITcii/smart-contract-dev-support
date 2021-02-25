# Checks-Effects-Interactions Pattern

## Context
The Checks-Effects-Interactions Pattern is applicable when smart contracts interact with other smart contracts to prevent reentrancy attacks. Reentrancy attacks can occur when a smart conntract makes function calls in an inconsistent state. An inconsistent state is characterized by inconsistent values in a smart contract. For example, assets of an account are transferred from a smart contract to another address but the variables that keep track of that account's balance are updated after the transfer.

``Applies to: [] EOSIO    [X] Ethereum    [] Hyperledger Fabric``
## Problem
The objective of the Checks-Effects-Interactions Pattern is to prevent reentrancy attacks from being successfull. Reentrancy should not be fully prevented but should be aborted after a certain condition is met. No additional instructions should be implemented in the smart contract. The problem is if a condition in a smart contract (e.g., `if(…)`) the values of the variables used in the condition are updated too late, it may lead to unintended program flow. For example, late updates of such variables could lead to numerous unintended recursions during the execution of smart contract functions (referred to as reentrancy) because a condition cannot be validated as false to interrupt execution. 
## Forces
The main force involved in the Checks-Effects-Interactions Pattern is implementation soundness particulary semantic soundness as the application of the Checks-Effects-Interactions Pattern prevents unintended program flow in smart contracts caused by reentrancy attacks.

## Solution
Developers must first update values of all variables used in the condition (e.g., `withdraw(...)`) before proceeding with the execution of smart contract code.
## Example
### Wrong
```Solidity 
pragma solidity 0.7.0;

// This smart contract is vulnerable to reentrancy and DoS
contract ChecksEffectsInteractionsAntipattern {
    mapping (address => uint256) public balances;

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
The Checks-Effects-Interactions Pattern prevents unintended program flow (e.g., due to reentrancy) because all values of variables relevant for a condition are updated as soon as possible. Thus, malicious actions that take advantage of unintended program flow (e.g., in reentrancy attacks) can be avoided.
## Rationale
Smart contracts follow the concept of state machines and make a transition from a state st to st+1 after certain variable values changed. Each function invocation is put on the call stack and needs to be processed before the smart contract terminates and the state transitions conclude. Unintended program flows are caused by the validation of conditions before the variable values relevant for the condition are updated. To prevent such unintended program flow, an appropriate order of operations in smart contracts regarding state transitions is crucial. With appropriate error handling updates of the internal value in a smart contract are rolled back if the smart contract has failed.
## Related Patterns
[External-Call](../../Idioms/External-Call%20Pattern/README.md), [Mutex Pattern](../../Design%20Patterns/Mutex%20Pattern/README.md), [Pull Pattern](../../Design%20Patterns/Pull%20Pattern/README.md)
## Known Uses
[ItemRegistry](https://etherscan.io/address/0x17df117bb806a622d841bd5166a23b5d8746232f/#code) (lines 181ff)
