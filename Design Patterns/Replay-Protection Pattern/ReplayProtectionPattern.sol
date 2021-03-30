pragma solidity 0.7.0;

contract ReplayProtectionPattern{
    uint256 executionNonce = 0;
    
    function execute(uint256 _operationType, address _to, uint256 _value,
        bytes calldata _data, uint256 _executionNonce, bytes calldata _signature)
        external {
        // Limit the number of execution nonces that can be skipped to avoid overflows.
        require(_executionNonce >= executionNonce && _executionNonce <= executionNonce + 1e9);
        
        // Increment the stored nonce
        executionNonce = _executionNonce + 1;
        
        // Execute the function
        someFunction();
    }
    
    function someFunction() private {
        // Do something
    }
}
