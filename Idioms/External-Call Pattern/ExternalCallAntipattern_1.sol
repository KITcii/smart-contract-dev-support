pragma solidity ^0.7.0;

contract ExternalContract {
    function externalFunction(string memory text1, string memory text2)
       public pure returns (bool) {
        return keccak256(bytes(text1)) == keccak256(bytes(text2));
    }
}
