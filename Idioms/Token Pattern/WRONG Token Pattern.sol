pragma solidity >=0.6.10 <0.7.0;

contract TokenContract {
    address public minter;
    
    mapping (address => uint256) public balances;
    uint256 highest_bid = 0;
    address highest_bidder;

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

    function auction(uint256 bid) public {
        require(balances[msg.sender] >= bid, "Insufficient balance.");
        require(bid>highest_bid, "Your bid is too low.");
        
        highest_bidder=msg.sender;
        highest_bid=bid;
    }
}
