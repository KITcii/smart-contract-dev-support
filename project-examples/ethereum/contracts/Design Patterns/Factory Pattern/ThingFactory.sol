// SPDX-License-Identifier: MIT
// https://github.com/optionality/clone-factory (Solidity 0.423)

pragma solidity ^0.7.0;

import "./Thing.sol";
import "./CloneFactory.sol";
import "./Ownable.sol";


contract ThingFactory is CloneFactory {

  address public libraryAddress;

  event ThingCreated(address newThingAddress, address libraryAddress);

  constructor (address _libraryAddress) {
    libraryAddress = _libraryAddress;
  }

  function onlyCreate() public {
    createClone(libraryAddress);
  }

 // Added Data Location
  function createThing(string memory _name, uint _value) public {
    address clone = createClone(libraryAddress);
    Thing(clone).init(_name, _value);
    emit ThingCreated(clone, libraryAddress);
  }

  function isThing(address thing) public view returns (bool) {
    return isClone(libraryAddress, thing);
  }

 // Added Data Location
  function incrementThings(address[] memory things) public returns (bool) {
    for(uint i = 0; i < things.length; i++) {
      require(isThing(things[i]), "Must all be things");
      Thing(things[i]).increment();
    }

  }
}