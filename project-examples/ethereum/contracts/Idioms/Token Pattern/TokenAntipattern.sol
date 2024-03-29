// SPDX-License-Identifier: MIT

pragma solidity 0.7.0;

contract TokenAntipattern {
    address public minter;
    mapping (address => uint256) public balances;
    uint256 highest_bid = 0;
    address highest_bidder;

    event Sent(address from, address to, uint amount);

    constructor() {
        minter = msg.sender;
    }

    function mint(address _receiver, uint _amount) public returns(uint256) {
        require(msg.sender == minter);
        
        balances[_receiver] += _amount;
        return balances[_receiver];
    }

    function send(address _receiver, uint _amount) public returns(bool) {
        require(_amount <= balances[msg.sender], "Insufficient balance.");
        
        balances[msg.sender] -= _amount;
        balances[_receiver] += _amount;
        emit Sent(msg.sender, _receiver, _amount);
        return true;
    }

    function auction(uint256 _bid) public {
        require(balances[msg.sender] >= _bid, "Insufficient balance.");
        require(_bid>highest_bid, "Your bid is too low.");
        
        highest_bidder=msg.sender;
        highest_bid=_bid;
    }
}
