// SPDX-License-Identifier: MIT

pragma solidity 0.7.0;

contract GuardingPattern {
    address public owner;

    event OwnerChanged(string message);

    modifier onlyOwner() {
        require(owner == msg.sender, "Not authorized!");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function changeOwner(address _newOwner) public onlyOwner {
        owner = _newOwner;
        emit OwnerChanged("Change Successful");
    }
}
