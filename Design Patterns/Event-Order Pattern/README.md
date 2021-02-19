# Event-Order Pattern

## Context
Multiple users want to interact with the same smart contract in a certain state _s<sub>t</sub>_ using their individual accounts. If the smart contract makes a transition from _s<sub>t</sub>_ to a subsequent state _s<sub>t+1</sub>_, the execution of the smart contract may cause undesired outcomes for the respective transaction issuer. Therefore, the transactions issuers want to have a guarantee that the smart contract function is only executed in the intended state or not at all.

## Problem
The state of a smart contract in which a transaction triggers a smart contract function cannot be foreseen because of concurrency in transaction processing and unpredictable event ordering due to non-deterministic behavior of validating nodes. Concurrency in transaction processing may lead to unintended outcomes of smart contract execution such as transfers of unintended amounts of assets (e.g., Ether), especially in scenarios requiring conditional execution of transactions.

## Forces
A smart contract function should be executed in a user-defined state _s_. After a transaction triggered the execution of a smart contract in _s_, all concurrent transactions that aim to execute the smart contract in _s_ must be rejected.

## Solution
Developers can implement a state value that indicates the current state of the smart contract (a transition number in the following example). In each function call, a target state value is expected as an argument. If the state value included in the transaction equals the current state value of the smart contract, the function is executed. Otherwise, the transaction is rejected and the function is not executed. After the smart contract state changed, the smart contract’s state value changes accordingly.

The value range of the state value must be large enough to ensure that no transactions can be held in the nodes' mempools until the state value of the smart contract matches the intended state of such old transactions again. In Solidity, for example, overflow should be considered when implementing integer counters as state values.

## Example (based on [10])

### Wrong
```Solidity
pragma solidity ^0.7.0;
 
contract EventOrderAntipattern {

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
                "Current smart contract state does not match targeted state.");
         transCounter += 1;
         _;
    }
}

contract EventOrder is TransitionCounter {

    function a(uint _nextTransNum) public transitionCounting(_nextTransNum) {
        // Code to be executed in a certain state
    }
}
```
The above example **does only consider the state of the smart contract a transaction should be processed in**, regardless of the issuer of the individual transaction issuers. To allow for conditional executions like A aims to execute subsequent transactions _tx<sub>1</sub>_ in smart contract state _s<sub>0</sub>_ and _tx<sub>2</sub>_ in _s<sub>1</sub>_, while B aims to also execute the smart contract with _tx<sub>B,1</sub>_ in _s<sub>0</sub>_), the modifier needs to be extended to consider _msg.sender._


## Resulting Context
Smart contract functions that implement a state value condition are only executed by transactions that carry a matching state value. Otherwise, transactions are rejected. A drawback is that updates for the transition counter must also be paid by users that execute the smart contract.

## Rationale
Using a variable indicating the state of a smart contract, the execution of smart contract functions in a certain state is assured. If a smart contract function should be executed in a state, in which the transition counter does not equal an intended value, the execution is aborted.

## Related Patterns
[Mutex Pattern](/Design%20Patterns/Mutex%20Pattern/README.md#context), 

## Known Uses
[ETOCommitment](https://etherscan.io/address/0x01a1f17808edae0b004a4f11a03620d3d804b997#code) (lines 762 ff, 6735)
