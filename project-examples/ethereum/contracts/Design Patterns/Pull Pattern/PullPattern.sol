// SPDX-License-Identifier: MIT

pragma solidity 0.7.0;

contract PullPattern {
    mapping (address => uint) public balances;
    event AccountBalance(uint balance);
    
    receive() external payable {
        balances[msg.sender] = msg.value;
    }

    function getBalance() external {
        emit AccountBalance(balances[msg.sender]);
    }

    function payout() public {
        require(balances[msg.sender] > 0, "No balance available.");

        uint amount = balances[msg.sender];
        balances[msg.sender] = 0;

        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Transaction failed.");

        emit AccountBalance(balances[msg.sender]);
    }
}
