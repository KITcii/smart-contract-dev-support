// SPDX-License-Identifier: MIT

pragma solidity 0.7.0;

contract DeactivationAntipattern {
    address payable internal owner;

    modifier onlyOwner() {
        require(owner == msg.sender, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    receive() external payable {}

    function close() public onlyOwner {
        selfdestruct(msg.sender);
    }
}
