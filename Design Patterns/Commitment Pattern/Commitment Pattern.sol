pragma solidity >=0.6.10 <0.7.0;

contract Commitment { 
    struct UserCommit { 
        bytes32 secretCommit; 
        bytes32 secretSalt; 
        string plainValue; 
        string plainSalt;

    } 

    mapping(address => UserCommit) public userCommits;

    function commit(bytes32 secretCommit, bytes32 secretSalt) public { 
        require(userCommits[msg.sender].secretCommit == "", "Your commitment cannot be changed anymore.");

        UserCommit memory uC = userCommits[msg.sender]; 
        uC.secretCommit = secretCommit; 
        uC.secretSalt = secretSalt; 
        userCommits[msg.sender] = uC;

    }

    function reveal(string memory plainSalt, string memory plainValue) public { 
        require(userCommits[msg.sender].secretCommit != "", "You did not commit to a value"); 
        require(userCommits[msg.sender].secretSalt == keccak256(abi.encode(plainSalt)), "Your salt does not match the original one."); 
        require(userCommits[msg.sender].secretCommit == keccak256(abi.encodePacked(plainSalt, plainValue)), "Invalid values.");

        userCommits[msg.sender].plainSalt = plainSalt;
        userCommits[msg.sender].plainValue = plainValue;

    }

}