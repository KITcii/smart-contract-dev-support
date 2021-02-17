pragma solidity ^0.7.0;

// Definition of the interface of ExternalContract for easier integration into ExternalCallPattern
contract ExternalContract {
    function externalFunction(string memory _text1, string memory _text2)
       public pure returns (bool) {
        return keccak256(bytes(_text1)) == keccak256(bytes(_text2));
    }
}

contract ExternalCallPattern {
    event Response(string text);

    modifier isContract(address _externalAddress) view internal returns (bool) {
        uint size;
        assembly { size := extcodesize(_externalAddress) }
        require (size > 0);
        _;
    }

    function doSomething(address _externalAddress, string memory _text1,
      string memory _text2) public isContract(_externalAddress) {

        // Check if a smart contract is available at the given address to avoid, for example, asset loss when sending asset
        require(isContract(_externalAddress), "No smart contract available at given address!");


        // Instantiate ExternalContract to make direct calls with revert(…) in case of failures in the function execution
        ExternalContract c = ExternalContract(_externalAddress);
        bool equal = c.externalFunction(_text1, _text2);    
   
        // Check return value of c.externalFunction(…)
        require(equal, "Texts are NOT equal.");
        emit Response("Texts are equal.");
    }
}
