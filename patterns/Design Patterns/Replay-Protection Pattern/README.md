# Replay-Protection Pattern

## Context
Transactions are publicly visible and include payload data that can be reissued by attackers to leverage benefits, for example, to spend assets on different distributed ledgers after a hard fork.

``Applies to: [X] EOSIO    [X] Ethereum    [] Hyperledger Fabric``

## Problem
In replay attacks, attackers use data included in transactions (e.g., digital signatures for authentication) issued by other identities and resend the transaction, for example, to manipulate token balances kept by a smart contract. The aim of the Replay-Protection Pattern is to protect smart contracts from replay attacks.

## Forces
The forces involved are semantic soundness and resource efficiency. Semantic soundness can be improved by preventing replay attacks and, thus, improving robustness of the smart contract. However, the Replay-Protection Pattern requires additional checks that increase resources consumption.

## Solution
Add a digital signature to the parameters to be passed to the function. Using the digital signature, all other function parameters and a nonce are signed to make their integrity provable and authenticate the identity that must authorize the function execution. The nonce to be passed is determined by the smart contract and changes after each function call. Only if the digital signature is valid, the function will be executed.

## Example
### Wrong
```Solidity
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
        
        // Forgot to increment the nonce
        _;
    }

    constructor() {
        owner = msg.sender;
    }
    
    //...
    
}
```

### Correct
```Solidity
pragma solidity 0.7.0;

import "./ECDSA.sol";

contract ReplayProtectionPattern{
    uint256 private executionNonce = 0;
    mapping(address => uint256) private balances;
    
    address owner;
    
    modifier replayProtection(address _from, address _to, uint256 _amount,
        uint256 _executionNonce, bytes calldata _signature) { 
        // Increment the stored nonce
        executionNonce = _executionNonce + 1;
        
        // Check signature
        address signer = ECDSA.recover(
            ECDSA.toEthSignedMessageHash(
                keccak256(abi.encodePacked(_from, _to, _amount, address(this), _executionNonce))
            )
            , _signature
        );
        require(signer == owner, "invalid signature / wrong signer / wrong nonce.");
        _;
    }

    constructor() {
        owner = msg.sender;
    }
    
    //...
    
    function transferTokens(address _from, address _to, uint256 _amount, uint256 _executionNonce, bytes calldata _signature)
        external replayProtection(_from, _to, _amount, _executionNonce, _signature) {
        require(balances[_from] > _amount, "Not enough funds available!");
        require(msg.sender == owner, "You are not the owner!");
        balances[_from] = balances[_from] - _amount;
        balances[_to] = balances[_to] + _amount;
    }

    function buyTokens() external payable {
        balances[msg.sender] = balances[msg.sender] + msg.value;
    }
    
    function withdrawTokens() external {
        require(balances[msg.sender] > 0, "No funds available!");
        uint256 amount = balances[msg.sender];
        balances[msg.sender] = 0;
        msg.sender.transfer(amount);
    }
}
```

## Resulting Context
Whenever a function protected by the Replay-Protection Pattern is called, the signature sent with the call must match the signature of the passed parameters and the current nonce. The nonce is changed after each function call, which is why the function call is only successful once. All other calls will be denied.

Consider the number of transactions that can be processed by the smart contract within a same short time frame. If a large number of transactions that include a digital signature with the same nonce is likely to be sent to the smart contract in a short time frame, only the first transaction received by the contract will be processed. After processing the first transaction with the valid nonce, the nonce changes and all other transactions with signatures using the old nonce will be invalid.

## Rationale
By using nonce in a digital signature that changes after each function call, the digital signature can be used only once. Subsequent function calls with the same digital signature become invalid.

## Related Patterns
\-

## Known Uses
[IdentityContract](https://github.com/B2E2/b2e2_contracts/blob/master/contracts/IdentityContract.sol) (lines 94ff)
