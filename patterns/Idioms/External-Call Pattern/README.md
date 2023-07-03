# External-Call Pattern

## Context
The External-Call Pattern applies whenever calls to external smart contracts are made.

``Applies to: [] EOSIO    [X] Ethereum    [] Hyperledger Fabric``

## Problem
When a smart contract initiates a call, it is unknown if the called address is associated with an externally owned account or a smart contract, if the smart contract is available and includes the target function, and if the called function execution succeeds. Not considering these options in smart contract development can cause smart contract vulnerabilities and, for example, asset loss or denial of service. The External-Call Pattern is to handle calls to external smart contracts with options to appropriately handle failed calls and prevent unintended side effects. Values returned by invoked functions of the external smart contract should be accessible, and  appropriate error handling should be possible. In Solidity, several primitives to call smart contract functions (e.g., `call(...)`, `delegatecall(...)`) can cause unintended side effects, such as invoking the fallback function of the recipient. 

## Forces
The forces involved in the External-Call Pattern are extensibility, reusability, semantic soundness and resource efficiency. By calling on existing code in external smart contracts, the extensibility and reusability of smart contract code are enabled securely by the External-Call Pattern. Moreover, the External-Call Pattern is applied to handle errors and avoid unintended side effects, thus, increasing implementation soundness. Nonetheless, the External-Call Pattern requires additional code to make checks and handle errors, decreasing resource efficiency. 

## Solution
Treat any external calls as malicious and evaluate each return value from external function calls regarding its intended outcome. Treating a smart contract as malicious includes the consideration of undesired side effects caused by such an external smart contract (e.g., reentrancy). Appropriate error handling should be implemented for the case that an exception is thrown during the execution of the external function. For example, if you cannot use direct calls to a smart contract but only `<address>.call(abi.encodeWithSignature("foo(…)",…)`, you should be aware that `call(…)` does only revert state changes after the `call(…)` command and implement a corresponding `require(…)` or `revert(…)` command. To ease error handling, isolate each external function call through individual transactions.
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

    modifier isContract(address _externalAddress) {
        uint size;
        assembly { size := extcodesize(_externalAddress) }
        require (size > 0, 'Address does not point to a smart contract!');
        _;
    }
    
    function doSomething(address _externalAddress, string memory _text) public isContract(_externalAddress) {
        require(isContract(_externalAddress), "The target address is not a smart contract!");
        
        (bool success, bytes memory data) = _externalAddress.call(
            abi.encodeWithSignature("externalFunction(string)", _text)
        );

        // Check if function has been executed successfully
        emit Response(success, data);
    }
}
```
CallerContract uses the `<address>.call(...)` command to execute `<address>.externalFunction(...)` because ExternalContract is not known. The call returns a tuple that indicates whether the function execution was successful (variable success) and data. The variable data must be parsed in additional functions to retrieve the return value of `<contract>.externalFunction(...)`. 

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
    modifier isContract(address _externalAddress) {
        uint size;
        assembly { size := extcodesize(_externalAddress) }
        require (size > 0, 'Address does not point to a smart contract!');
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
CallerContract directly calls `<contract>.externalFunction(...)` of ExternalContract, whose interfaces are known to CallerContract because of the definition of ExternalContract in the same file. If an exception is thrown during the execution of `<contract>.externalFunction(...)`, all state changes are reverted. Otherwise, <contract>.externalFunction(...) returns its Boolean return value.

## Resulting Context
When importing external smart contracts, vulnerabilities of these external smart contracts can be handled by appropriate error handling, also under consideration of the returned values. In the case an exception is thrown, all state changes are reverted automatically. However, the smart contract deployment becomes more expensive because a kind of copy of the external smart contract is included in the file of the custom smart contract to define the interface of the external smart contract.

## Rationale
The solc compiler does not check whether called non-primitive data types comply with the interface of the called smart contract. No exception is thrown in case the called smart contract executes another function than intended; for example, the fallback function of a smart contract if the signature of the function to be executed does not exist. The External-Call Pattern mitigates these challenges by excluding the use of external smart contracts or treating all external contracts as malicious.

## Related Patterns
[Checks-Effects-Interactions Pattern](../Checks-Effects-Interactions%20Pattern/README.md), [Error-Handling Pattern](../Error-Handling%20Pattern/README.md), [Mutex Pattern](../../Design%20Patterns/Mutex%20Pattern/README.md)

## Known Uses
[Kitty Core](https://etherscan.io/address/0x06012c8cf97BEaD5deAe237070F9587f8E7A266d#code) (lines 1598,1691)
