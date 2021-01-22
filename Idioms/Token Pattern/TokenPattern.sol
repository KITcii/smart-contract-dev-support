pragma solidity >=0.5.0 <0.7.0;

// Separate the logic from the actual token storage in favor of maintenance.

contract TokenPattern {
    address public minter;
    mapping (address => uint) public userBalances;
    event Sent(address from, address to, uint amount);

    constructor() public {
        minter = msg.sender;
    }

    function mint(address receiver, uint amount) public returns(uint256) {
        // Equals function mint(…) of the wrong example lines 17-20
    }

    function send(address receiver, uint amount) public returns(bool) {
        // Equals function send(…) of the wrong example lines 24-29
    }
}

contract LogicContract {
    address owner;
    TokenContract t;
    address public highest_bidder;
    uint256 highest_bid;

    constructor() public {
        owner = msg.sender;
    }
    
    function changeToken (address _address) public {
        require(msg.sender == owner);
        t = TokenContract(_address);
    }

    function auction(uint256 bid) public {
        require(t.userBalances(msg.sender) >= bid, "Insufficient balance.");
        require(bid>highest_bid, "Your bid is too low.");
        
        highest_bidder=msg.sender;
        highest_bid=bid;
    }
