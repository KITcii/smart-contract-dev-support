// SPDX-License-Identifier: MIT

pragma solidity 0.7.0;

contract DeactivationAntipattern {
    address payable owner;

    constructor() {
      owner = msg.sender;
    }

    modifier onlyOwner(){
        require (owner == msg.sender, "Not authorized");
        _;
    }

    receive() external payable {
    }
    
    function close() public onlyOwner { 
      selfdestruct(msg.sender); 
    }

}