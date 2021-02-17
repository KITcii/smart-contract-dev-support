# Guarding Pattern
## Context
A smart contract has sensible logic implemented and should only be executable by certain accounts in defined contexts.

## Problem
Smart contract interfaces are directly exposed to and callable by all users of the distributed ledgers.

## Forces
A function should be executable by only certain accounts and the authorization checks should be performed prior to the function execution. Required authorization checks must be implemented efficiently.

## Solution
Developers should implement authorization checks (e.g., modifiers in solidity) for callable functions, especially for those functions that should transfer assets. In Solidity, the use of a modifier is recommended to implement procedures (e.g., authorization checks) that are executed prior to the execution of the actual function called. Modifiers implement “_;” to indicate at which position the actual function code should be executed. Modifiers can be implemented in multiple functions.

## Example

### Wrong
```Solidity 
pragma solidity >=0.5.0 <0.7.0;

contract GuardingAntipattern {
    address public owner = msg.sender;

    function changeOwner(address newOwner) public
        returns(bool){
        owner = newOwner;
        return true;    
    }
}
```

### Correct
```Solidity 
pragma solidity >=0.5.0 <0.7.0;

contract GuardingPattern {
    address public owner = msg.sender;

    // Use a modifier to define your guarding conditions
    modifier onlyBy(address account){
        require(msg.sender == account, "Not authorized!");
        _;
    }

    function changeOwner(address newOwner) public
        onlyBy(owner){
        owner = newOwner;
    }
}

```

## Resulting Context
All smart contract functions that handle sensitive logic, check the validity of the request directly at the beginning of the function call and will not execute any code of a function if the authorization check validates as false. Using modifiers supports understandability and allows to recycle code within a smart contract instead of implementing individual checks in each function.

## Rationale
A lack of authorization checks endangers funds kept in a smart contract because malicious smart contract function calls (e.g., certain accounts or certain smart contract execution contexts) can be successful. Using modifiers allows for an intuitive and reusable way of implementing certain procedures, such as authorization checks, that should be executed when calling a smart contract function.

## Related Patterns
\-

## Known Uses
[EthereumLottery](https://etherscan.io/address/0x40658db197bddeA6a51Cb576Fe975Ca488AB3693#code) (lines 65ff)
