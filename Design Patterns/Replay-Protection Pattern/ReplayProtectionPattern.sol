pragma solidity 0.7.0;

contract ReplayProtectionPattern{
    uint256 executionNonce = 0;
    
    mapping<address, uint256> balances;
    
    function execute(uint256 _operationType, address _to, uint256 _value,
        bytes calldata _data, uint256 _executionNonce, bytes calldata _signature)
        external {
        // Limit the number of execution nonces that can be skipped
        require(_executionNonce >= executionNonce && _executionNonce <= executionNonce + 1e9);
        
        // Check signature
        // TODO
        
        // Increment the stored nonce
        executionNonce = _executionNonce + 1;
        
        // Execute the function
        transferTokens();
    }
    
    function transferTokens() private {
        require(balances[msg.sender] > 0, "No funds available!");
        uint256 value = balances[msg.sender];
        balances[msg.sender] = 0;
        msg.sender.transfer(value);
    }
    
    function receiveFunds() external payable {
        balances[msg.sender] = balances[msg.sender] + msg.value;
    }
}
