// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

contract MutexPattern {
    bool internal locked = false;
    mapping(address => uint256) public balances;

    modifier noReentrancy {
        require(!locked, "Blocked from reentrancy.");
        locked = true;
        _;
        locked = false;
    }

    receive() external payable {
        balances[tx.origin] += msg.value;
    }

    function withdraw(uint256 _amount) public noReentrancy {
        require(balances[tx.origin] >= _amount, "No balance to withdraw.");

        // This is wrong according to the Checks-Effects-Interaction Pattern.
        // For demonstration purposes only!
        (bool success, ) = msg.sender.call{value: _amount}("");
        balances[tx.origin] -= _amount;

        require(success, "Transaction failed.");
    }
}
