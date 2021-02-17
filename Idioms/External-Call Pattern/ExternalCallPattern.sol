pragma solidity >=0.6.10 <0.7.0;

// Definition of the interface of ExternalContract to be able to easily use the defined return values
contract ExternalContract {
    function externalFunction(string memory text1, string memory text2)
       public pure returns (bool) {
        return keccak256(bytes(text1)) == keccak256(bytes(text2));
    }
}

contract ExternalCallPattern {
    event Response(string text);

    function doSomething(address _externalAddress, string memory _text1,
      string memory _text2) public {

        // Check if a smart contract is available at the given address to avoid, for example, asset loss when sending asset
        require(isContract(_externalAddress), "No smart contract available at given address!");


        // Instantiate ExternalContract to make direct calls with revert(…) in case of failures in the function execution
        ExternalContract c = ExternalContract(externalAddress);
        bool equal = c.externalFunction(text1, text2);    
   
        // Check return value of c.externalFunction(…)
        require(equal, "Texts are NOT equal.");
        emit Response("Texts are equal.");
    }

    // Check if a smart contract exists on the given address
    function isContract(address _externalAddress) view internal returns (bool) {
        uint size;
        assembly { size := extcodesize(_externalAddress) }
        return (size > 0);
    }
}
