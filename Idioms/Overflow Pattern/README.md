# Overflow Pattern
## Context
Overflow can occur when the value range of an integer variable is exceeded. For example, if a variable is declared with the keyword var and a small value (e.g., 0) at compile time, the Solc compiler converts the variable type to the smallest suitable integer type (uint8).

## Problem
The inappropriate use of data types can cause overflow of the respective unsigned integer variables, which may cause wrong calculations or infinite loops. Overflow of (unsigned) integer variables describes the case that the value assigned to a variable exceeds the maximum value of the declared data type (e.g., 255 for uint8). As a result, the EVM starts from 0 again and adds up the rest of the value to be assigned. The EVM jumps back to its maximum value according to its declared data type and decrements the carriable value by the corresponding negative value to be assigned (e.g., for uint8 variables the finally assigned value for -3 would be 252). If a variable is in-/decremented as a counter in a loop, overflow can occur leading to infinite loops.

## Forces
The function execution should be aborted in the case of an overflow and the executing user must be notified through an appropriate error message.

## Solution
When assigning a value to an integer variable, the value range of the variable’s data type must be considered to avoid unintended side effects. To facilitate checks when assigning a value to a variable, libraries such as OpenZeppelin SafeMath for Solidity should be used. Furthermore, developers should avoid var type inference and specify the data type explicitly to make the smart contract code better to comprehend. Using the OpenZeppelin SafeMath library, all operations are reverted in case of an overflow because an except is thrown because of a failed assert(…).

## Example

### Wrong
```Solidity 
pragma solidity ^0.6.0;

contract OverflowAntipattern {
    function runLoop() public {
        for(uint8 i=255; i < 300 ; i+1{
            // Your code
        }
    }
}

```
### Correct
```Solidity 
pragma solidity ^0.6.0;

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
            // Your code
        }
    }
}
```
## Resulting Context
Each time a value is assigned to a variable, the value range of the data type of the variable is checked and values that exceed the value range of the data type are not assigned, but an exception is thrown.
## Rationale
Smart contracts are not considered safe because of implicit data type inferences by the Solc compiler in presence of the keyword var and its cyclic behavior when exceeding the maximum values of the declared data type. The OpenZeppelin SafeMath library checks arithmetic operations (e.g., incrementing or decrementing variables) to prevent overflow.
## Related Patterns
External-Call Pattern
## Known Uses
BecToken (lines 53ff): https://etherscan.io/address/0xc5d105e63711398af9bbff092d4b6769c82f793d#code
