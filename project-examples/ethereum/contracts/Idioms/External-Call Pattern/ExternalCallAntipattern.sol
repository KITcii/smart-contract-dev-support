pragma solidity 0.7.0;

contract CallerContract {
    event Response(bool success, bytes data);

     modifier isContract(address _externalAddress) {
        uint size;
        assembly { size := extcodesize(_externalAddress) }
        require (size > 0, "Address does not point to a smart contract!");
        _;
    }

    function doSomething(address _externalAddress, string memory _text) 
        public isContract(_externalAddress) {
        
        (bool success, bytes memory data) = _externalAddress.call(
            abi.encodeWithSignature("externalFunction(string)", _text)
        );

        // Check if function has been executed successfully
        emit Response(success, data);
    }

}
