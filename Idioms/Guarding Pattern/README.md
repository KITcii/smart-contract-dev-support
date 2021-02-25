# Guarding Pattern
## Context
The Guarding Pattern applies to smart contracts that should only be executable by particular accounts in defined contexts. 

``Applies to: [X] EOSIO    [X] Ethereum    [X] Hyperledger Fabric``

## Problem
The objective of the Guarding Pattern is to ensure a function is only executable by particular accounts and the authorization checks should be performed prior to the function execution. The problem that arises is that smart contract interfaces are directly exposed to and callable by all users of the distributed ledgers. 

## Forces
The forces involved in the Guarding Pattern are regulated executability particulary execution restriction, semantic soundness and resource efficiency. Execution restrictions are enabled by the implementation of authorization checks. This also increases semantic soundness as only the intended accounts are able to invoke smart contract interfaces. The implementation of authorization checks do require additional computational resources, thus, reducing resource efficiency.

## Solution
Developers should implement authorization checks (e.g., `modifiers` in Solidity) for callable functions, especially for those functions that should transfer assets. In Solidity, the use of a modifier is recommended to implement procedures (e.g., authorization checks) that are executed prior to the execution of the actual function called. Modifiers implement `_;` to indicate at which position the actual function code should be executed. Modifiers can be implemented in multiple functions.

## Example

### Wrong
```Solidity 
pragma solidity 0.7.0;

contract GuardingAntipattern {
    address public owner = msg.sender;

    function changeOwner(address _newOwner) public
        returns(bool){
        owner = _newOwner;
        return true;    
    }
}
```

### Correct
```Solidity 
pragma solidity 0.7.0;

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
