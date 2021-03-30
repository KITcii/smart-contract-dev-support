pragma solidity 0.7.0;

contract ReplayProtectionPattern{
    
    function execute(uint256 _operationType, address _to, uint256 _value, bytes calldata _data, uint256 _executionNonce, bytes calldata _signature) external {
        // Limit the number of execution nonces that can be skipped to avoid overflows.
        require(_executionNonce >= executionNonce && _executionNonce <= executionNonce + 1e9);
        
        // Increment the stored execution nonce first.
        // This prevents the replay attacks where a contract that is called later and replays the call to the execution function.
        executionNonce = _executionNonce + 1;
        IdentityContractLib.execute(owner, _executionNonce, _operationType, _to, _value, _data, _signature);
    }
}
