# Problem
Exceptions in smart contract code are thrown if the smart contract runs out of gas, an assertion fails, or the call stack limit is reached. Insufficient error handling can lead to denial of service and smart contracts may even automatically lock their balances.
# Context
Error handling in smart contract execution is a particular challenge in Ethereum because exceptions are not uniformly handled by the Ethereum Virtual Machine (EVM). Smart contract functions are executed in a call chain, which is a sequence of function invocations during a function execution. These function invocations can refer to functions within the same smart contract (internal) or functions of other smart contracts (external). There are two types of call chains that behave differently when exceptions are thrown: direct calls and delegate calls. When using only direct calls (e.g., contract.method(…)), all changes are reverted if an exception is thrown in the call chain. When using delegate calls, the call chain includes the command sequence call ➔ delegatecall ➔ send and propagates exceptions up the call chain until it reaches the next call command. This call command returns false. From this point on, the smart contract function execution is resumed. Only changes caused by the failed call are reverted and only the gas allocated to this call is consumed. This behavior becomes critical when the smart contract runs out-of-gas during a loop operation, which handles several external accounts. After the smart contract’s state changed, it cannot be reverted. Invocations of external functions can even cause denial of service if conditions (e.g., in if(…), for(…), or while(…)) depend on invocations of functions of other smart contracts. Such invocations may always fail and, thus, inhibit callers from finishing the execution of a transaction.

With Solidity 0.6.x, the try/catch error handling construct has been introduced. However, try/catch error handling constructs only apply to external function calls and contract creation calls. Only state changes in external functions are rolled back and those of the calling function are not
# Forces
Appropriate error handling in Ethereum smart contracts requires sophisticated knowledge about the error propagation and the call chain in the smart contract stack because errors are not handled uniformly in Ethereum. Implementing such error handlings will, however, increase gas cost for deployment and execution because of larger smart contract code and may decrease readability of the code.
# Solution
Implementing checks of return values (e.g., of call(…) or delegatecall(…) functions) can ensure that errors will be handled appropriately. For such error handling, Solidity offers require(…) and revert(…) instructions. Both function refund left over gas and allow to return an error message. While require(…) and revert(…) can be used for the same purposes, revert(…) should be used for more complex conditions (e.g., nested conditions) in favor of better readability. With introducing Solidity 0.6.x, error handling for the invocation of external smart contract functions can be implemented with the try/catch error handling construct.
# Example

## require(…) and revert(…):
```Solidity 
pragma solidity 0.6.10;

contract Sharer {

    function sendAssets(address payable addr)
       public payable returns (bool) {
        require (!addr.call{value: (msg.value / 2)}(""),
                   "Asset transfer failed.");
        return true;
    }

    function sendAssetsMoreComplex(address payable addr)
       public payable returns (bool) {
        if(block.difficulty < 1000) {
            if(!addr.call{value: (msg.value / 2)}("")) {
                revert("Asset transfer failed.");
            } else {
                return true;
            }
        }      
        return true;
    }
}

```
## External call with try/catch:
```Solidity 
pragma solidity ^0.6.1;
import "./CharitySplitter.sol";

contract CharitySplitterFactory {
    mapping (address => CharitySplitter) public charitySplitters;
    uint public errorCount;
    
    event ErrorHandled(string reason);

    function createCharitySplitter(address _charityOwner) public {
        try new CharitySplitter(_charityOwner)
            returns (CharitySplitter newCharitySplitter) { 
                charitySplitters[msg.sender] = newCharitySplitter;
        } catch Error(string memory reason) {
            errorCount++;
            CharitySplitter newCharitySplitter = new CharitySplitter(msg.sender);
            charitySplitters[msg.sender] = newCharitySplitter;
            // Emitting the error in event
            emit ErrorHandled(reason);
        } catch {
            errorCount++;
        }
    }
    
    // Your code
}
```

Based on: https://blog.ethereum.org/2020/01/29/solidity-0.6-try-catch/
# Resulting Context
Appropriate error handling increases robustness and ensures the functioning of the smart contract resulting in increased reliability of the smart contracts. For example, smart contract’s state changes can be reverted by implementing a throw statement. However, code for error handling increases gas cost for the deployment of the smart contracts and all gas is consumed when throwing an exception to revert all state changes.
# Rationale
Error handling in smart contracts is not handled uniformly, which is why individual error handling must be implemented und consideration of the call chain.
# Related Patterns

# Known Uses
EthereumLottery (lines 261, 291ff) : https://etherscan.io/address/0x40658db197bddeA6a51Cb576Fe975Ca488AB3693#code

E93 (lines 1061, 1095ff): https://etherscan.io/address/0xdd2ee38f9993c0bc1c1b5b9798bc4deff66cac4a#code 

MinereumLuckDraw (lines 165ff, 158ff) : https://etherscan.io/address/0xc0cfe587c9f1fedd6d0aa8532fd759a65d6e7568#code