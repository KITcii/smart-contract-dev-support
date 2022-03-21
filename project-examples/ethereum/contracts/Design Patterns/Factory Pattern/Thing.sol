// SPDX-License-Identifier: MIT
// https://github.com/optionality/clone-factory/tree/master/test
pragma solidity ^0.7.0;

contract Thing {

  string public name;
  uint public value;

  event ThingEvent(address sender, string name, uint value);

  constructor() {
    name = "master"; // force default deployment to be init'd
  }

//Added Data Location
  function init(string memory _name, uint _value) public {
    require(bytes(name).length == 0); // ensure not init'd already.
    require(bytes(_name).length > 0);

    name = _name;
    value = _value;
  }

  function doit() public {
    emit ThingEvent(address(this), name, value);
  }

//Added Data Location
  function epicfail() public returns (string memory){
    value++;
    require(false, "Hello world!");
    return "Goodbye sweet world!";
  }

  function increment() public {
    value++;
  }
}