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
