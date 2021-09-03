// SPDX-License-Identifier: MIT

pragma solidity 0.7.0;

contract CommitmentPattern {
    struct UserCommit { 
        bytes32 secretCommit; 
        bytes32 secretSalt; 
        string plainValue; 
        string plainSalt;
    }

    event TestCommit(bytes32);
    event TestSalt(bytes32);

    event RevealCommit(bytes32);
    event RevealSalt(bytes32);

    mapping(address => UserCommit) public userCommits;

    function commit(bytes32 _secretCommit, bytes32 _secretSalt) public {
        require(userCommits[msg.sender].secretCommit == "", "Your commitment cannot be changed anymore.");

        emit TestCommit(_secretCommit);
        emit TestSalt(_secretSalt);

        UserCommit memory uC = userCommits[msg.sender];
        uC.secretCommit = _secretCommit;
        uC.secretSalt = _secretSalt;

        userCommits[msg.sender] = uC;
    }

    function reveal(string memory _plainSalt, string memory _plainValue) public { 
        require(userCommits[msg.sender].secretCommit != "", "You did not commit to a value"); 
        emit RevealCommit(keccak256(abi.encode(_plainSalt)));
        emit RevealSalt(keccak256(abi.encodePacked(_plainSalt, _plainValue)));
        
        //require(userCommits[msg.sender].secretSalt == keccak256(abi.encode(_plainSalt)), "Your salt does not match the original one."); 
        //require(userCommits[msg.sender].secretCommit == keccak256(abi.encodePacked(_plainSalt, _plainValue)), "Invalid values.");

        userCommits[msg.sender].plainSalt = _plainSalt;
        userCommits[msg.sender].plainValue = _plainValue;
    }
}
