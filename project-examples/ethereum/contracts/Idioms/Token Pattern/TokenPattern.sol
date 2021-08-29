pragma solidity 0.7.0;

import './Token.sol';

contract TokenPattern {
    address owner;
    Token public t;
    address public highest_bidder;
    uint256 highest_bid;

    constructor(Token _address) {
        owner = msg.sender;
        t = Token(_address);
    }
    
    function changeToken (address _address) public {
        require(msg.sender == owner);
        t = Token(_address);
    }

    function auction(uint256 bid) public {
        require(t.balances(msg.sender) >= bid, "Insufficient balance.");
        require(bid>highest_bid, "Your bid is too low.");
        
        highest_bidder=msg.sender;
        highest_bid=bid;
    }
}    
