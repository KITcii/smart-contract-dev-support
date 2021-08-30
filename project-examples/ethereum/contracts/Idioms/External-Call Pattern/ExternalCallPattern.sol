pragma solidity 0.7.0;

// Definition of the interface of ExternalContract for easier integration into ExternalCallPattern
import './ExternalContract.sol';

contract ExternalCallPattern {
    event Response(string text);

    //debugging
    event CallEvent(string message);
    event ContractSize(uint contractSize);

    function isContract(address _externalAddress) internal returns (bool) { //view internal
        uint size;
        assembly { size := extcodesize(_externalAddress) }
        emit ContractSize(size);
        require (size > 0);
        return true;
    }

    function doSomething(address _externalAddress, string memory _text1,
      string memory _text2) public {
        // Check if a smart contract is available at the given address to avoid, for example, asset loss when sending asset
        require(isContract(_externalAddress), "No smart contract available at given address!");

        emit CallEvent("External Call started");
        // Instantiate ExternalContract to make direct calls with revert(…) in case of failures in the function execution
        ExternalContract c = ExternalContract(_externalAddress);
        bool equal = c.externalFunction(_text1, _text2);    
   
        // Check return value of c.externalFunction(…)
        require(equal, "Texts are NOT equal.");
        emit Response("Texts are equal.");
    }
}
