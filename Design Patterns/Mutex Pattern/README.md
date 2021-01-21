# Context
Recursive calls of a smart contract function before its termination (referred to as reentrancy) can occur if a smart contract function allows, for example, external function calls in an inconsistent state. Such an inconsistent state is characterized by contradicting variable values. For instance, an account’s balance may be recorded in a mapping and be updated after a transfer of assets. In the time between the assets have been sent and the balance is updated in the mapping, the smart contract is in an inconsistent state as illustrated in the example.

There are three types of reentrancy and the Mutex Pattern applies to all of them. First, in cross-function reentrancy, a smart contract function is invoked and re-entered through another function, while the smart contract is still in an inconsistent state. Second, delegated reentrancy occurs when a smart contract imports other smart contracts (e.g., as a smart contract library) and state-updates of these smart contracts are not synchronized appropriately. Third, create-based reentrancy can occur if one smart contract calls the constructor of another smart contract and updates its state afterwards. The constructor can invoke external functions such as the original smart contract and, thus, reenter the original function.
# Problem
Unintended reentrancy can lead to manipulation of a smart contract’s state and even allow for theft of assets kept in the smart contract.
# Forces
The intended program flow of the smart contract should be assured. Especially, the smart contract functions should be protected from unintended side effects of, for example, calls-to-the-unknown and resulting reentrancy. Nevertheless, cost for the deployment and execution of the smart contract should not increase.
# Solution
Implement a mutex variable that prevents concurrent access to a variable and to protect critical parts of smart contract code, in which inconsistencies may occur (e.g., updating the balance of an account before sending those assets to the account). The mutex variable is a variable used in a condition that must validate as true to execute subsequent smart contract code. Otherwise, the code protected by the mutex variable is not executed. After the exe-cution of the protected smart contract code, the mutex is unlocked to allow for the next execution of the protected code. To protect a whole smart contract from reentrancy, such mutexes should be used in all of its functions.
# Example
## Wrong
```Solidity 
pragma solidity >=0.5.0 <0.7.0;

contract Reentrance {
    mapping(address => uint256) public balances;
    
    receive() external payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint amount) external {
        require(balances[msg.sender] >= amount
            "No balance to withdraw.");
        
        balances[msg.sender] -= amount;
        msg.sender.call{value: amount}("");
    }
}
```
## Correct
```Solidity 
pragma solidity >=0.5.0 <0.7.0;

contract Mutex {
    bool locked = false;
    mapping(address => uint256) public balances;
    
    modifier noReentrancy() {
        require(!locked, "Blocked from reentrancy.");
        locked = true;
        _;
        locked = false;
    }
    
    receive() external payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint amount) public payable
      noReentrancy returns(bool) {
        require(balances[msg.sender] >= amount, "No balance to withdraw.");
        
        balances[msg.sender] -= amount;
        bool success, ) = msg.sender.call{value: amount}("");
        require(success);

        return true;
    }
}

```
# Resulting Context
All state modifications are carried out if the flag is set true. Otherwise, function invocations are prevented if they are out of the intended order. There-fore, a reentrancy attack invoking recursive calls that exploit the inconsistent state of a smart contract can be prevented. The smart contract execution can become slightly costlier (e.g., in terms of gas) because of additional conditions to be considered using mutex variables.
# Rationale
By implementing the Mutex Pattern, a smart contract function cannot be executed if the function execution enters a certain point protected by a mutex variable until the function execution passed another point, where the mutex variable is unlocked again. In case an attacker aims to reenter the smart contract function, the execution will be aborted. By doing so, the smart contract function is protected from reentrancy.
# Related Patterns
Checks-Effects-Interactions Pattern
# Known Uses
CrowdsourceMinter (lines 60ff): https://etherscan.io/address/0xDa2Cf810c5718135247628689D84F94c61B41d6A#code

VentanaToken (lines 115ff): https://etherscan.io/address/0x30CefBcb5C26A5B19a019092Ab8d09F8739c904F#code