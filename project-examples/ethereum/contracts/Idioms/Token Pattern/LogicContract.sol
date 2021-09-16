// SPDX-License-Identifier: MIT

pragma solidity 0.7.0;

import './TokenContract.sol';

contract LogicContract {
    address owner;
    address public highest_bidder;

    TokenContract public t;

    uint256 highest_bid;
    uint public auctionEndTime;

    constructor(address payable _address, uint _timeLock) {
        owner = msg.sender;
        t = TokenContract(_address);
        auctionEndTime = block.timestamp + _timeLock;
    }
    
    function setTokenContractContract (address payable _address) public {
        require(msg.sender == owner);
        t = TokenContract(_address);
    }

    function bid(uint256 _bid) public {
        require(block.timestamp <= auctionEndTime, "Auction already ended.");
        // uint256 balance  = t.balances(msg.sender);
        // require( balance >= bid, "Insufficient balance.");
        require(_bid>highest_bid, "Your bid is too low.");
        
        highest_bidder=msg.sender;
        highest_bid=_bid;
    }



}    
