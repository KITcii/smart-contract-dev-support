pragma solidity 0.7.0;

contract ReplayProtectionPattern{
    uint256 private executionNonce = 0;
    mapping(address => uint256) private balances;
    
    address owner;
    
    constructor() {
        owner = msg.sender;
    }

    function transferTokens(address _from, address _to, uint256 _amount, uint256 _executionNonce) external {
        require(balances[_from] > _amount, "Not enough funds available!");
        require(msg.sender == owner, "You are not the owner!");
        balances[_from] = balances[_from] - _amount;
        balances[_to] = balances[_to] + _amount;
    }

    function buyTokens() external payable {
        balances[msg.sender] = balances[msg.sender] + msg.value;
    }
    
    function withdrawTokens() external payable {
        require(balances[msg.sender] > 0, "No funds available!");
        uint256 amount = balances[msg.sender];
        balances[msg.sender] = 0;
        msg.sender.transfer(amount);
    }
}
