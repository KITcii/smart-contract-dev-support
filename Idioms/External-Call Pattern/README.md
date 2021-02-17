# External-Call Pattern

## Context
To decrease storage consumption of distributed ledgers, already deployed smart contracts or libraries can be called from a smart contract.

## Problem
In Solidity, several primitives to call smart contract functions (e.g., call, delegatecall, send, transfer or direct function calls) may cause unin-tended side effects (e.g., by invoking the fallback function of the recipient).

## Forces
In favor of extensibility and reusability of smart contract code, code from external smart contracts should be executable intendedly with the option to appropriately handle failed calls. Values returned by invoked functions of the external smart contract should be accessible and an appropriate error handling should be possible.

## Solution
Treat any external calls as malicious and evaluate each return value from external function calls regarding its intended outcome. Treating a smart contract as malicious includes the consideration of undesired side effects caused by such external smart contract (e.g., reentrancy). Furthermore, appropriate error handling should be implemented for the case that an exception is thrown during the execution of the external function. For example, if you cannot use direct calls to a smart contract but only \<address>.call(abi.encodeWithSignature("foo(…)",…), you should be aware that call(…) does only revert state changes after the call(…) command and implement a corresponding require(…) or revert(…) command. To ease error handling, isolate each external function call through individual transactions.
## Example

### Wrong
```Solidity 
pragma solidity ^0.7.0;

contract ExternalContract {
    function externalFunction(string memory text1, string memory text2)
       public pure returns (bool) {
        return keccak256(bytes(text1)) == keccak256(bytes(text2));
    }
}
```
```Solidity 
pragma solidity ^0.7.0;

contract CallerContract {
    event Response(bool success, bytes data);

    function doSomething(address _externalAddress, string memory _text) public {
        (bool success, bytes memory data) = externalAddress.call(
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
```
CallerContract uses the call(…) command to execute externalFunction(…) because ExternalContract is not known. Call returns a tupel that indicates if the function execution was successful (variable success) and data. The variable data must be parsed in additional functions to retrieve the return value of externalFunction(…).

### Correct
```Solidity 
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
```
CallerContract directly calls externalFunction(…) of ExternalContract, whose interfaces are known to CallerContract because of the definition of ExternalContract in the same file. In the case an exception is thrown during the execution of externalFunction(…), all state changes are reverted. Otherwise, externalFunction(…) returns its Boolean return value.

## Resulting Context
When importing external smart contracts, vulnerabilities of these external smart contracts can be handled by appropriate error handling also under consideration of the returned values. In the case an exception is thrown, all state changes are reverted automatically. However, the smart contract deployment becomes more expensive because a kind of copy of the external smart contract is included in the file of the custom smart contract to define the interface of the external smart contract.

## Rationale
The Solc compiler does not check whether called non-primitive data types are compatible with the interface of the smart contract called. No exception is thrown in case the called smart contract executes another function than intended, for example, the fallback function of a smart contract if the signature of the function to be executed does not exist. The External-Call Pattern mitigates these challenges by excluding the use of external smart contracts or treating all external contracts as malicious.

## Related Patterns
[Checks-Effects-Interactions Pattern](../Checks-Effects-Interactions%20Pattern/README.md), [Error-Handling Pattern](../Error-Handling%20Pattern/README.md), [Mutex Pattern](../Mutex%20Pattern/README.md)

## Known Uses
[Kitty Core](https://etherscan.io/address/0x06012c8cf97BEaD5deAe237070F9587f8E7A266d#code) (lines 1598,1691)
