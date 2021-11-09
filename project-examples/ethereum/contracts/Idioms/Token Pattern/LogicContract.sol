// SPDX-License-Identifier: MIT

pragma solidity 0.7.0;

import './TokenContract.sol';

contract LogicContract {
    address owner;
    TokenContract public t;
    uint256 price;

    event ItemSold(uint256 value);
    
    constructor(address payable _address, uint _price) {
        owner = msg.sender;
        t = TokenContract(_address);
        price = _price;
    }

    function buy() public {
        require(t.balances(msg.sender) >= price, "Insufficient Funds");
        t.send(msg.sender, owner, price);
        emit ItemSold(price);
    }

}    
