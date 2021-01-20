pragma solidity >=0.6.10 <0.7.0;

contract CallerContract {
    event Response(bool success, bytes data);

    function doSomething(address externalAddress, string memory text) public {
        (bool success, bytes memory data) = externalAddress.call(
            abi.encodeWithSignature("externalFunction(string)", text)
        );

        // Check if function has been executed successfully
        emit Response(success, data);
    }

    function isContract(address addr) view internal returns (bool) {
        uint size;
        assembly { size := extcodesize(addr) }
        return (size > 0);
    }
}
