pragma solidity >=0.6.10 <0.7.0;

// To define the interface of the actually used ExternalContract
// to be able to easily use the defined return values
contract ExternalContract {
    function externalFunction(string memory text1, string memory text2)
       public pure returns (bool) {
        return keccak256(bytes(text1)) == keccak256(bytes(text2));
    }
}

contract CallerContract {
    event Response(string text);

    function doSomething(address externalAddress, string memory text1,
      string memory text2) public {
        // Instantiate ExternalContract to make direct calls
        // with automatic revert(…) in case of failures in
        // the function execution
        ExternalContract c = ExternalContract(externalAddress);
        bool equal = c.externalFunction(text1, text2);    
   
        // Check return value of c.externalFunction(…)
        require(equal, "Texts are NOT equal.");
        emit Response("Texts are equal.");
    }
}
