pragma solidity 0.7.0;

import './TokenContract.sol';

contract LogicContract {
    address owner;
    TokenContract public t;
    address public highest_bidder;
    uint256 highest_bid;

    constructor(address payable _address, uint _timeLock) {
        owner = msg.sender;
        t = TokenContract(_address);
    }
    
    function setTokenContractContract (address payable _address) public {
        require(msg.sender == owner);
        t = TokenContract(_address);
    }

    function auction(uint256 bid) public {
        require(t.balances(msg.sender) >= bid, "Insufficient balance.");
        require(bid>highest_bid, "Your bid is too low.");
        
        highest_bidder=msg.sender;
        highest_bid=bid;
    }



}    
