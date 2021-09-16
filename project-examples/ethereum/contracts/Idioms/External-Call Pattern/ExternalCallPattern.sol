// SPDX-License-Identifier: MIT

pragma solidity 0.7.0;

// Definition of the interface of ExternalContract for easier
// integration into ExternalCallPattern
import "./ExternalContract.sol";

contract ExternalCallPattern {
    event Response(string text);

    modifier isContract(address _externalAddress) {
        uint256 size;
        assembly {
            size := extcodesize(_externalAddress)
        }
        require(size > 0, "Address does not point to a smart contract!");
        _;
    }

    function doSomething(
        address _externalAddress,
        string memory _text1,
        string memory _text2
    ) public isContract(_externalAddress) {
        // Instantiate ExternalContract to make direct calls with 
        // revert(…) in case of failures in the function execution
        ExternalContract c = ExternalContract(_externalAddress);
        bool equal = c.externalFunction(_text1, _text2);

        // Check return value of c.externalFunction(…)
        require(equal, "Texts are NOT equal.");
        emit Response("Texts are equal.");
    }
}
