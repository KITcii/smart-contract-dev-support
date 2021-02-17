pragma solidity 0.7.0;

contract CallerContract {
    event Response(bool success, bytes data);

    function doSomething(address _externalAddress, string memory _text) public {
        (bool success, bytes memory data) = _externalAddress.call(
            abi.encodeWithSignature("externalFunction(string)", _text)
        );

        // Check if function has been executed successfully
        emit Response(success, data);
    }
}
