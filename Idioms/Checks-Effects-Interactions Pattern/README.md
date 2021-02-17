# Checks-Effects-Interactions Pattern

## Context
One smart contract should interact with another smart contract if a condition (e.g., if(A > B)) is validated as true. If the interaction was successfull, the variables used in the condition are updated. For example, an Ethereum smart contract offers CII tokens for Ether and should transfer Ether to an address if that address owns more than 0 CII tokens in the smart contract. After the successfull transfer of Ether, the CII token balance of the target address is updated.
## Problem
A condition in a smart contract (e.g., if(…)) cannot be validated as false because the values of the variables used in the condition are updated too late, which leads to unintended program flow. For example, late updates of such variables could lead to numerous unintended recursions during the execution of smart contract functions (referred to as reentrancy) because a condition cannot be validated as false to interrupt execution. 
## Forces
Reentrancy should not be fully prevented but should be aborted after a certain condition is met. No additional instructions should be implemented in the smart contract.
## Solution
Developers must first update values of all variables (used in the condition) before proceeding with the execution of smart contract code.
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
[Mutex Pattern](../../Design%20Patterns/Mutex%20Pattern/README.md)
## Known Uses
[ItemRegistry](https://etherscan.io/address/0x17df117bb806a622d841bd5166a23b5d8746232f/#code) (lines 181ff)
