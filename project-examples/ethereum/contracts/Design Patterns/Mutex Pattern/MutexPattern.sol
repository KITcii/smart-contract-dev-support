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
    
    receive() external payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint _amount) public noReentrancy returns(bool) {
        require(balances[msg.sender] >= _amount, "No balance to withdraw.");
        
        // This is wrong according to the Checks-Effects-Interaction Pattern.
        // For demonstration purposes only!
        (bool success, ) = msg.sender.call{value: _amount}("");
        balances[msg.sender] -= _amount;
        
        require(success);

        return true;
    }
}
