pragma solidity 0.7.0;

contract ReplayProtectionPattern{
    uint256 private executionNonce = 0;
    mapping(address => uint256) private balances;
    
    function execute(address _to, uint256 _value, uint256 _executionNonce,
        bytes calldata _signature) external {
        // Limit the number of execution nonces that can be skipped
        require(_executionNonce >= executionNonce && _executionNonce <= executionNonce + 1e9,
            "Invalid execution nonce!");
        
        // Check signature
        // TODO
        
        // Increment the stored nonce
        executionNonce = _executionNonce + 1;
        
        // Execute the function
        transferTokens(msg.sender, _to, _value);
    }
    
    function transferTokens(address _from, address _to, uint256 _amount) private {
        require(balances[_from] > _amount, "Not enough funds available!");
        balances[_from] = balances[_from] - _amount;
        balances[_to] = balances[_to] + _amount;
    }
    
    function withdrawTokens() private {
        require(balances[msg.sender] > 0, "No funds available!");
        uint256 amount = balances[msg.sender];
        balances[msg.sender] = 0;
        msg.sender.transfer(amount);
    }
    
    function receiveFunds() external payable {
        balances[msg.sender] = balances[msg.sender] + msg.value;
    }
}
