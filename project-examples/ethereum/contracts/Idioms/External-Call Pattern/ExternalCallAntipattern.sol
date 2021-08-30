pragma solidity 0.7.0;

contract CallerContract {
    event Response(bool success, bytes data);

    function doSomething(address _externalAddress, string memory _text) public {
        require(isContract(_externalAddress), "The target address is not a smart contract!");
        
        (bool success, bytes memory data) = _externalAddress.call(
            abi.encodeWithSignature("externalFunction(string)", _text)
        );

        // Check if function has been executed successfully
        emit Response(success, data);
    }

    function isContract(address _externalAddress) view internal returns (bool) {
        uint size;
        assembly { size := extcodesize(_externalAddress) }
        return (size > 0);
    }
}
