pragma solidity >=0.6.10 <0.7.0;

contract ExternalCallAntipattern {
    event Response(bool success, bytes data);

    function doSomething(address _externalAddress, string memory _text) public {
        (bool success, bytes memory data) = _externalAddress.call(
            abi.encodeWithSignature("externalFunction(string)", _text)
        );

        emit Response(success, data);
    }
}
