# External-Call Pattern

## Context
The External-Call Pattern is applicable whenever calls to external smart contracts are made.

``Applies to: [] EOSIO    [X] Ethereum    [] Hyperledger Fabric``

## Problem
The objective of the External-Call Pattern is to handle calls to external smart contracts intendedly with option to appropriately handle failed calls and prevent unintended side effects. Values returned by invoked functions of the external smart contract should be accessible and an appropriate error handling should be possible. The problem is that in Solidity, several primitives to call smart contract functions (e.g., `call(...)`, `delegatecall(...)`, `send(...)`, `transfer(...)` or direct function calls) may cause unintended side effects such as invoking the fallback function of the recipient. 

## Forces
The forces involved in the External-Call Pattern are extensibiltiy, reusibility, semantic soundness and resource efficiency. Extensibility and reusability of smart contract code by calling on existing code in external smart contracts is enabled securly by the External-Call Pattern. Moreover, the External-Call Pattern is applied handle errors and avoid unintended side effects, thus, increasing implementation soundness. Nonetheless, the External-Call Pattern requires additional code to make checks and handle error decreasing resource efficiency. 

## Solution
Treat any external calls as malicious and evaluate each return value from external function calls regarding its intended outcome. Treating a smart contract as malicious includes the consideration of undesired side effects caused by such external smart contract (e.g., reentrancy). Furthermore, appropriate error handling should be implemented for the case that an exception is thrown during the execution of the external function. For example, if you cannot use direct calls to a smart contract but only `<address>.call(abi.encodeWithSignature("foo(…)",…)`, you should be aware that `call(…)` does only revert state changes after the `call(…)` command and implement a corresponding `require(…)` or `revert(…)` command. To ease error handling, isolate each external function call through individual transactions.
## Example

### Wrong
```Solidity 
pragma solidity 0.7.0;

contract ExternalContract {
    string text = "EXAMPLE";

    function externalFunction(string memory _text)
       public pure returns (bool) {
        return keccak256(bytes(text)) == keccak256(bytes(_text));
    }
}
```
```Solidity 
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
```
CallerContract uses the `call(…)` command to execute `externalFunction(…)` because ExternalContract is not known. Call returns a tupel that indicates if the function execution was successful (variable success) and data. The variable data must be parsed in additional functions to retrieve the return value of `externalFunction(…)`.

### Correct
```Solidity 
pragma solidity 0.7.0;

// Definition of the interface of ExternalContract for easier integration into ExternalCallPattern
contract ExternalContract {
    function externalFunction(string memory _text1, string memory _text2) public pure returns (bool);
}

contract ExternalCallPattern {
    event Response(string text);

    // Check if a smart contract is available at the given address to avoid, for example, asset loss when sending asset
    modifier isContract(address _externalAddress) view internal returns (bool) {
        uint size;
        assembly { size := extcodesize(_externalAddress) }
        require (size > 0);
        _;
    }

    function doSomething(address _externalAddress, string memory _text1, string memory _text2)
        public isContract(_externalAddress) {
        // Instantiate ExternalContract to make direct calls with revert(…) in case of failures in the function execution
        ExternalContract c = ExternalContract(_externalAddress);
        bool equal = c.externalFunction(_text1, _text2);    
   
        // Check return value of c.externalFunction(…)
        require(equal, "Texts are NOT equal.");
        emit Response("Texts are equal.");
    }
}
```
CallerContract directly calls `<contract>.externalFunction(…)` of ExternalContract, whose interfaces are known to CallerContract because of the definition of ExternalContract in the same file. In the case an exception is thrown during the execution of `<contract>.externalFunction(…)`, all state changes are reverted. Otherwise, `<contract>.externalFunction(…)` returns its Boolean return value.

## Resulting Context
When importing external smart contracts, vulnerabilities of these external smart contracts can be handled by appropriate error handling also under consideration of the returned values. In the case an exception is thrown, all state changes are reverted automatically. However, the smart contract deployment becomes more expensive because a kind of copy of the external smart contract is included in the file of the custom smart contract to define the interface of the external smart contract.

## Rationale
The Solc compiler does not check whether called non-primitive data types are compatible with the interface of the smart contract called. No exception is thrown in case the called smart contract executes another function than intended, for example, the fallback function of a smart contract if the signature of the function to be executed does not exist. The External-Call Pattern mitigates these challenges by excluding the use of external smart contracts or treating all external contracts as malicious.

## Related Patterns
[Checks-Effects-Interactions Pattern](../Checks-Effects-Interactions%20Pattern/README.md), [Error-Handling Pattern](../Error-Handling%20Pattern/README.md), [Mutex Pattern](../../Design%20Patterns/Mutex%20Pattern/README.md)

## Known Uses
[Kitty Core](https://etherscan.io/address/0x06012c8cf97BEaD5deAe237070F9587f8E7A266d#code) (lines 1598,1691)
