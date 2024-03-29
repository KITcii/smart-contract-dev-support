// SPDX-License-Identifier: MIT

pragma solidity 0.7.0;

contract ChecksEffectsInteractionsAntipattern {
    mapping (address => uint256) public balances;

    receive() external payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint _amount) public{
        
        // Checks

        //poor checks
        if(balances[msg.sender] >= _amount){ 
            // Interactions
            (bool success,) = msg.sender.call{value: _amount}("");
            require(success);
            // Effects
            balances[msg.sender] -= _amount;
        }
    }
}