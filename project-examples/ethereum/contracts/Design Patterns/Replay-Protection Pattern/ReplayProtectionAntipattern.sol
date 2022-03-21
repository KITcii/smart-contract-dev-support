// SPDX-License-Identifier: MIT
pragma solidity 0.7.0;

import "./ECDSA.sol";

contract ReplayProtectionAntipattern{
    uint256 private executionNonce = 0;
    mapping(address => uint256) public balances;
    
    address owner;
    
    modifier replayProtection(address _from, address _to,
        uint256 _amount, uint256 _executionNonce, bytes calldata _signature) {
        // Limit the number of execution nonces that can be skipped
        require(_executionNonce >= executionNonce && _executionNonce <= executionNonce + 1e9,
            "Invalid execution nonce!");
        
        // Check signature
        address signer = ECDSA.recover(
            ECDSA.toEthSignedMessageHash(
                keccak256(abi.encodePacked(_from, _to, _amount, address(this), _executionNonce))
            )
            , _signature
        );
        require(signer == owner, "Invalid signature.");
        
        // Forgetting to increment the nonce
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function transferTokens(address _from, address _to, uint256 _amount, uint256 _executionNonce, bytes calldata _signature)
        external replayProtection(_from, _to, _amount, _executionNonce, _signature) {
        require(balances[_from] > _amount, "Not enough funds available!");
        require(msg.sender == owner, "You are not the owner!");

        balances[_from] = balances[_from] - _amount;
        balances[_to] = balances[_to] + _amount;
    }

    receive() external payable {
        balances[msg.sender] = balances[msg.sender] + msg.value;
    }
    
    function withdrawTokens() external {
        require(balances[msg.sender] > 0, "No funds available!");
        uint256 amount = balances[msg.sender];
        balances[msg.sender] = 0;
        msg.sender.transfer(amount);
    }
}
