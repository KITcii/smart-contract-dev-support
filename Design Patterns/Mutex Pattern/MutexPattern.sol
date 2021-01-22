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

    function withdraw(uint amount) public payable noReentrancy returns(bool) {
        require(balances[msg.sender] >= amount, "No balance to withdraw.");
        
        balances[msg.sender] -= amount;
        bool success, ) = msg.sender.call{value: amount}("");
        require(success);

        return true;
    }
}
