pragma solidity ^0.7.0;

contract MutexAntipattern {
    mapping(address => uint256) public balances;
    
    receive() external payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint _amount) external {
        require(balances[msg.sender] >= _amount, "No balance to withdraw.");
        
        balances[msg.sender] -= _amount;
        msg.sender.call{value: _amount}("");
    }
}
