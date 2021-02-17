pragma solidity ^0.7.0;

contract TokenPattern {
    address public minter;
    mapping (address => uint) public balances;
    event Sent(address from, address to, uint amount);

    constructor() public {
        minter = msg.sender;
    }

    function mint(address receiver, uint amount) public returns(uint256) {
        require(msg.sender == minter);
        
        balances[receiver] += amount;
        return balances[receiver];
    }

    function send(address receiver, uint amount) public returns(bool) {
        require(amount <= balances[msg.sender], "Insufficient balance.");
        
        balances[msg.sender] -= amount;
        balances[receiver] += amount;
        emit Sent(msg.sender, receiver, amount);
        return true;
    }

}

contract LogicContract {
    address owner;
    TokenPattern t;
    address public highest_bidder;
    uint256 highest_bid;

    constructor() public {
        owner = msg.sender;
    }
    
    function changeToken (address _address) public {
        require(msg.sender == owner);
        t = TokenPattern(_address);
    }

    function auction(uint256 bid) public {
        require(t.balances(msg.sender) >= bid, "Insufficient balance.");
        require(bid>highest_bid, "Your bid is too low.");
        
        highest_bidder=msg.sender;
        highest_bid=bid;
    }
}    
