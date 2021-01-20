pragma solidity >=0.5.0 <0.7.0;

contract PullContract {
    mapping (address => uint256) public balances;
    
    receive() external payable {
        balances[msg.sender] = msg.value;
    }

    function payout() public {
        require(balances[msg.sender] > 0, "No balance available.");

        uint256 amount = balances[msg.sender];
        balances[msg.sender] = 0;
        msg.sender.call{value: amount}("");
    }
}
