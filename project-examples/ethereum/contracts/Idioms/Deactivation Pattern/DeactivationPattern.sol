// SPDX-License-Identifier: MIT

pragma solidity 0.7.0;

contract DeactivationPattern {
    address payable internal owner;
    bool internal activated = true;

    modifier checkActive() {
        require(activated, "Contract is deactivated");
        _;
    }

    modifier onlyOwner() {
        require(owner == msg.sender, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    receive() external payable checkActive {}

    function anyFunction() public checkActive {
        // code to be reverted by deactivation
    }

    function setActive(bool _active) public onlyOwner {
        activated = _active;
    }
}
