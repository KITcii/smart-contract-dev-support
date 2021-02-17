# Commitment Pattern
## Context
Values stored in a smart contract must not be visible to other users until a certain point in time but must be binding for the issuer of the respective values.

## Problem
Users should be able to commit to a certain value but keep it secret from others and disclose the committed value later.

## Forces
The values to which users have committed themselves must be kept secret until the individual users want to reveal their values. In addition, these values must be binding for respective users and changes of the values after the commitment must be at least recognizable or prevented. The secret values should be impossible or at least very hard to guess for attackers.

## Solution
Implement a smart contract that includes a mechanism for the commit phase and a mechanism for the reveal phase. During the commit phase, users send values they want to commit to the Commitment Contract in disguised form (e.g., hashes of these values) so that no other user knows the original values. The Commitment Contract stores all disguised values in a tamper-resistant way. To disguise the original values, the range of possible original values and their disguised representation must be considered. Otherwise, the original values may be easy to guess. For example, the corresponding pre-image of a hash value may be easy to guess by other users in scenarios with only few original values (e.g., a value v ∊ {1, 2, 3}) because hash functions are deterministic. To avoid easy guessing of the original values, a random salt must be added to each value before disguising the value.

During the subsequent reveal phase, all users send their original values and the used random salt to the Commitment Contract. The Commitment Contract compares the received values with the corresponding disguised values that the respective user has sent in the commit phase. One approach to check if the plain values correspond to the disguised values is to apply the identical procedure (e.g., keccak to hash the concatenation of the plain value and the salt) and compare the outcome of this procedure with the commitment.

## Example

```Solidity
pragma solidity ^0.7.0;

contract CommitmentPattern {
    struct UserCommit { 
        bytes32 secretCommit; 
        bytes32 secretSalt; 
        string plainValue; 
        string plainSalt;
    }

    mapping(address => UserCommit) public userCommits;

    function commit(bytes32 _secretCommit, bytes32 _secretSalt) public {
        require(userCommits[msg.sender].secretCommit == "", "Your commitment cannot be changed anymore.");

        UserCommit memory uC = userCommits[msg.sender];
        uC.secretCommit = _secretCommit;
        uC.secretSalt = _secretSalt;

        userCommits[msg.sender] = uC;
    }

    function reveal(string memory _plainSalt, string memory _plainValue) public { 
        require(userCommits[msg.sender].secretCommit != "", "You did not commit to a value"); 
        require(userCommits[msg.sender].secretSalt == keccak256(abi.encode(_plainSalt)), "Your salt does not match the original one."); 
        require(userCommits[msg.sender].secretCommit == keccak256(abi.encodePacked(_plainSalt, _plainValue)), "Invalid values.");

        userCommits[msg.sender].plainSalt = _plainSalt;
        userCommits[msg.sender].plainValue = _plainValue;
    }
}
```

Note: We did not implement events for the sake of simplicity of the example. For a better integration into software applications, events should be implemented at the end of the commit(…) and/or reveal(…) function.

## Resulting Context
The smart contract stores the disguised values in a tamper-resistant way and all commits are binding. The disguised values can be revealed by users afterwards. Developers should consider the case that not all users will reveal their secret values.

## Rationale
All transactions and their contents stored on the distributed ledger are publicly transparent. Therefore, the secret values to which the users have committed themselves are already stored on the distributed ledger in a tamper-resistant manner. The challenge is to keep the data secret from potentially malicious users who might try to uncover the secret value. Therefore, we recommend adding a salt to the secret value and allowing only the issuer of the secret value to reveal it.

## Related Patterns
\-

## Known Uses
[Registrar](https://etherscan.io/address/0x6090A6e47849629b7245Dfa1Ca21D94cd15878Ef#code) (lines 344ff)
