// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

contract PullAntipattern {
    address payable[] clients;
    mapping (address => uint256) public balances;
    
    receive() external payable {
        balances[msg.sender] = msg.value;
        clients.push(msg.sender);
    }

    function payout() public {
        for (uint256 i = 0; i < clients.length; i++) {
            clients[i]. call{value: balances[clients[i]]}("");
        }
    }
}
