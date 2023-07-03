# Event-Order Pattern

## Context
The Event-Order Pattern is applicable when nodes determine the order of transaction processing, leading to a kind of concurrency.

``Applies to: [X] EOSIO    [X] Ethereum    [X] Hyperledger Fabric``

## Problem
When a transaction is issued to a DLT network to invoke a smart contract, with nodes in the network determining the order of transaction execution, a kind of concurrency occurs between transactions with respect to the execution of the smart contract. The concurrency in transaction processing makes the state in which the target smart contract is finally executed unpredictable. Since the smart contract state may change the results of the smart contract execution (e.g., in terms of fees to be paid), transactions issuers may want to have a guarantee that the smart contract will only be executed in a certain state or not at all. For this purpose, the Event-Order Pattern is applied.

## Forces
The forces involved in the Event-Order Pattern are determinism, particularly transaction-order dependence and code efficiency, particularly required interactions. Because the non-determinist behavior of validating nodes to achieve certainty that the transaction will be carried out in the intended states or not at all requires the implementation of additional mechanisms. These mechanisms ensure that the intended transaction-order is adhered to. This is realized at the cost of deploying additional smart contract code, which increases the required interactions between smart contracts. 

## Solution
Implement a variable whose value indicates the current state of the smart contract (e.g., a transition number in the following example). For each function call, an argument is expected that expresses the desired state for executing the smart contract. If the desired state matches the current state of the smart contract, the function is executed; otherwise, the transaction is rejected. After function execution, the state value of the smart contract is updated.
The value range of the state value must be large enough to ensure that transactions cannot be held in a node's mempool until the value of the state variable again matches the desired state of those transactions. For example, in Solidity, overflow should be considered when implementing integer counters as state values.

## Example (based on [10])

### Wrong
```Solidity
pragma solidity ^0.7.0;
 
contract EventOrderAntipattern {

    //...

    function a() {
        // Code to be executed in any state
    }
}

``` 

### Correct
```Solidity
pragma solidity ^0.7.0;

contract EventOrderPattern {
    uint256 transCounter = 0;

    modifier transitionCounting(uint256 _nextTransNum){
         require(transCounter == _nextTransNum,
                "Current smart contract state does not match desired state.");
         transCounter += 1;
         _;
    }
    //...
}

contract EventOrder is TransitionCounter {
    //...
    function a(uint _nextTransNum) public transitionCounting(_nextTransNum) {
        // Code to be executed in a certain state
    }
}
```
The above example **does only consider the state of the smart contract a transaction should be processed in**, regardless of the issuer of the individual transaction. To allow for conditional executions like A aims to execute subsequent transactions _tx<sub>1</sub>_ in smart contract state _s<sub>0</sub>_ and _tx<sub>2</sub>_ in _s<sub>1</sub>_, while B aims to also execute the smart contract with _tx<sub>B,1</sub>_ in _s<sub>0</sub>_, the modifier needs to be extended to consider _msg.sender._


## Resulting Context
Smart contract functions that implement a condition for the smart contract state are only executed by transactions that pass a matching value for the desired state. However, the implementation and updates of transition counters cause computational overhead.

## Rationale
If a smart contract function should be executed in a specific state in the presence of concurrent transaction ordering, identities can specify the desired state. The smart contract execution is aborted if the desired state does not match the current smart contract state.

## Related Patterns
[Mutex Pattern](/Design%20Patterns/Mutex%20Pattern/README.md#context)

## Known Uses
[ETOCommitment](https://etherscan.io/address/0x01a1f17808edae0b004a4f11a03620d3d804b997#code) (lines 762 ff, 6735)
