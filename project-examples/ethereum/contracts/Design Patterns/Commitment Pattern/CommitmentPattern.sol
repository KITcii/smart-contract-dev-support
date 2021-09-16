// SPDX-License-Identifier: MIT

pragma solidity 0.7.0;

contract CommitmentPattern {
    struct UserCommit {
        bytes32 secretValue;
        bytes32 secretSalt;
        string plainValue;
        string plainSalt;
    }

    mapping(address => UserCommit) public userCommits;

    event Commit(bytes32 value, bytes32 salt);
    event Reveal(bytes32 value, bytes32 salt);

    function commit(bytes32 _secretValue, bytes32 _secretSalt) public {
        require(
            userCommits[msg.sender].secretValue == "",
            "Your commitment cannot be changed anymore."
        );

        UserCommit memory uC = userCommits[msg.sender];
        uC.secretValue = _secretValue;
        uC.secretSalt = _secretSalt;

        userCommits[msg.sender] = uC;

        emit Commit(_secretValue, _secretSalt);
    }

    function reveal(string memory _plainValue, string memory _plainSalt) public {
        require(userCommits[msg.sender].secretValue != "", "You did not commit to a value.");
        require(
            userCommits[msg.sender].secretSalt == keccak256(abi.encode(_plainSalt)),
            "Your salt does not match the original one."
        );
        require(
            userCommits[msg.sender].secretValue ==
                keccak256(abi.encodePacked(_plainValue, _plainSalt)),
            "Invalid values."
        );

        userCommits[msg.sender].plainValue = _plainValue;
        userCommits[msg.sender].plainSalt = _plainSalt;

        emit Reveal(
            keccak256(abi.encodePacked(_plainValue, _plainSalt)),
            keccak256(abi.encode(_plainSalt))
        );
    }
}
