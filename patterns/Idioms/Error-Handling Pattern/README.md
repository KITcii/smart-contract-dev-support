# Error-Handling Pattern

## Context
The Error-Handling Pattern is applicable when smart contracts have external dependencies or possibly invalid conditions that may cause errors. 

``Applies to: [] EOSIO    [X] Ethereum    [] Hyperledger Fabric``
## Problem
In Ethereum, exceptions are not uniformly handled. Smart contract functions are executed in a call chain, which is a sequence of function invocations during function execution. Appropriate error handling in Ethereum smart contracts requires sophisticated knowledge about the error propagation and the call chain in the smart contract stack because errors are not handled uniformly in Ethereum. The aim of the Error-Handling Pattern is to appropriately handle errors occurring in smart contracts correctly and prevent denial of service or the locking of balances.

## Forces
The forces involved in the Error-Handling Pattern are semantic soundness, readability and resource efficiency. Semantic soundness is increased because risks associated with the insufficient handling of errors are mitigated. However, implementing such error handling will increase gas cost for deployment and execution because of larger smart contract code and may decrease readability of the code.

## Solution
Implementing checks of return values (e.g., of `call(…)` or `delegatecall(…)` functions) can ensure that errors will be handled appropriately. For such error handling, Solidity offers `require(…)` and `revert(…)` instructions. Both function refund leftover gas and allow to return an error message. While `require(…)` and `revert(…)` can be used for the same purposes, `revert(…)` should be used for more complex conditions (e.g., nested conditions) in favor of better readability. With introducing Solidity 0.6.x, error handling for the invocation of external smart contract functions can be implemented with the try/catch error handling construct.

## Example

### require(…) and revert(…):
```Solidity 
pragma solidity 0.6.10;

contract ErrorHandlingPatternRequireRevert {
    //...
    function sendAssets(address payable _addr)
        public payable returns (bool) {
            (bool success, ) = _addr.call{value: (msg.value / 2)}("");
            require (success, "Asset transfer failed.");
            return true;
    }

    function sendAssetsMoreComplex(address payable _addr)
        public payable returns (bool) {
            if(block.difficulty < 1000) {
                (bool success, ) = _addr.call{value: (msg.value / 2)}("");
                if(!success) {
                    revert("Asset transfer failed.");
                } else {
                    return true;
                }
            }      
            return true;
     }
}
```
### External call with try/catch:
```Solidity 
pragma solidity ^0.6.1;

contract CharitySplitter {
    address public owner;
    constructor (address _owner) public {
        require(_owner != address(0), "no-owner-provided");
        owner = _owner;
    }
}

contract ErrorHandlingPatternTryCatch {
    mapping (address => ChildContract) public childContracts;
    uint public errorCount;
    
    event ErrorHandled(string reason);
    //...
    function createCharitySplitter(address _childOwner) public {
        try new ChildContract(_childOwner)
            returns (ChildContract newChildContract) {
                charitySplitters[msg.sender] = newChildContract;
        } catch Error(string memory reason) {
            errorCount++;
            ChildContract newChildContract = new ChildContract(msg.sender);
            childContracts[msg.sender] = newChildContract;
            // Emit the error event
            emit ErrorHandled(reason);
        } catch {
            errorCount++;
        }
    }
}
```
Note that with try/catch, only exceptions happening inside the external call itself are caught.
Based on: https://blog.ethereum.org/2020/01/29/solidity-0.6-try-catch/

## Resulting Context
Appropriate error handling increases robustness and ensures the functioning of the smart contract resulting in increased reliability of the smart contracts. For example, smart contract state changes can be reverted by implementing a throw statement. However, code for error handling increases the gas cost for the deployment of the smart contracts, and all gas is consumed when throwing an exception to revert all state changes.

## Rationale
Error handling in smart contracts is not handled uniformly. Thus, error handling must be individually implemented under consideration of the call chain. There are two types of call chains that behave differently when exceptions are thrown: direct calls and delegate calls. When using only direct calls (e.g., `contract.method(…)`), all changes are reverted if an exception is thrown in the call chain. When using delegate calls, the call chain includes the command sequence `call` ➔ `delegatecall` ➔ `send` and propagates exceptions up the call chain until it reaches the next call command. This call returns false. From this point on, the smart contract function execution is resumed. Only changes caused by the failed call are reverted and only the gas allocated to this call is consumed. This behavior becomes critical when the smart contract runs out-of-gas during a loop operation, which handles several external accounts. After the smart contract state is changed, it cannot be reverted. Invocations of external functions can even cause a denial of service if conditions (e.g., in `if(…)`, `for(…)`, or `while(…)`) depend on invocations of functions of other smart contracts. Such invocations may always fail and, thus, inhibit callers from finishing the execution of a transaction.

With Solidity 0.6.x, the `try/catch` error handling construct has been introduced. However, `try/catch` error handling constructs only apply to external function calls and contract creation calls. Only state changes in external functions are rolled back, and those of the calling function are not.

## Related Patterns
[External-Call Pattern](../../Idioms/External-Call%20Pattern/README.md)

## Known Uses
[EthereumLottery](https://etherscan.io/address/0x40658db197bddeA6a51Cb576Fe975Ca488AB3693#code) (lines 261, 291ff), 
[E93](https://etherscan.io/address/0xdd2ee38f9993c0bc1c1b5b9798bc4deff66cac4a#code) (lines 1061, 1095ff), 
[MinereumLuckDraw](https://etherscan.io/address/0xc0cfe587c9f1fedd6d0aa8532fd759a65d6e7568#code) (lines 165ff, 158ff)
