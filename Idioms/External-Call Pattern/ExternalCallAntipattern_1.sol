pragma solidity ^0.7.0;

contract ExternalContract {
    function externalFunction(string memory _text1, string memory _text2)
       public pure returns (bool) {
        return keccak256(bytes(_text1)) == keccak256(bytes(_text2));
    }
}
