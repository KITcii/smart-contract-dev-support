pragma solidity 0.7.0;

contract Token {
    address public minter;
    mapping (address => uint) public balances;
    
    event Sent(address from, address to, uint amount);

    constructor() {
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