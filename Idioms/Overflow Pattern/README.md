# Overflow/Underflow Pattern
## Context
The Overflow Pattern is applicable when handling numeric data types in smart contracts, where the variable values overflow or underflow if the as-signed value exceeds the boundary of representable values. Overflow of integer variables describes the case that the value assigned to a variable ex-ceeds the maximum value that can be represented by the declared data type (e.g., ``255`` for ``uint8``). The variable value returns to the smallest representable number (i.e., ``0`` for ``uint8``) and adds up the rest of the value to be assigned. In underflow, the variable value exceeds the lower boundary of representable values by a data type and jumps back to its maximum value and decrements the carriable value by the corresponding negative value to be assigned (e.g., for uint8 variables the finally assigned value for ``-3`` would be ``252``). 

``Applies to: [] EOSIO    [X] Ethereum    [] Hyperledger Fabric``
## Problem
Overflow and underflow can cause wrong calculations or infinite loops. The aim of the Overflow/Underflow Pattern is to avoid overflow and underflow. If overflow occurs, the function execution should be aborted, and an appropriate error message must notify the entity that initiated the execution of the function. 

## Forces
The forces involved are implementation soundness particulary appropriate variable use, code efficiency and readibility. The overflow patterns improves implementation soundness by avoiding the occurence of overflows and the related consequences, but comes at the cost of being less efficient and slightly less readable through the usage of libraries (e.g. OpenZeppelin SafeMath).

## Solution
When assigning a value to an integer variable, the value range of the variable’s data type must be considered to avoid unintended side effects. To facilitate checks when assigning a value to a variable, libraries such as OpenZeppelin SafeMath for Solidity should be used. Furthermore, developers should avoid var type inference and specify the data type explicitly to make the smart contract code better to comprehend. Using the OpenZeppelin SafeMath library, all operations are reverted in case of an overflow because an except is thrown because of a failed ``assert(…)``.

## Example

### Wrong
```Solidity 
pragma solidity 0.7.0;

contract OverflowAntipattern {
    function runLoop() public {
        for(uint8 i=255; i < 300 ; i+1{
            //...
        }
    }
}

```
### Correct
```Solidity 
pragma solidity 0.7.0;

// We integrate only the part of the SafeMath8 library relevant for this pattern 
library SafeMath8 {
    // Customized SafeMath for uint8
    function add(uint8 a, uint8 b) internal pure
      returns (uint8) {
        uint8 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }
}

contract OverflowPattern {
    using SafeMath8 for uint8;
       
    function runLoop() public {
        for(uint8 i=255; i < 300 ; i.add(1)){
            //...
        }
    }
}
```
## Resulting Context
Each time a value is assigned to a variable, the value range of the data type of the variable is checked and values that exceed the value range of the data type are not assigned, but an exception is thrown.

## Rationale
Smart contracts are not considered safe because of implicit data type inferences by the Solc compiler in presence of the keyword var and its cyclic behavior when exceeding the maximum values of the declared data type. The OpenZeppelin SafeMath library checks arithmetic operations (e.g., incrementing or decrementing variables) to prevent overflow and underflow.

## Related Patterns
[External-Call Pattern](../External-Call%20Pattern/README.md)
## Known Uses
[BecToken](https://etherscan.io/address/0xc5d105e63711398af9bbff092d4b6769c82f793d#code) (lines 53ff)
