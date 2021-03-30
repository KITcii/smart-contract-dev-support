pragma solidity 0.7.0;

contract ReplayProtectionAntipattern {
    
    function execute(uint256 _operationType, address _to, uint256 _value, bytes calldata _data, uint256 _executionNonce, bytes calldata _signature) external {
        IdentityContractLib.execute(owner, _executionNonce, _operationType, _to, _value, _data, _signature);
    }
}
