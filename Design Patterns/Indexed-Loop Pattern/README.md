# Context
Unbounded mass operations occur when developers use iteratable data structures (e.g., lists or collections) to store an unlimited number of elements (e.g., accounts) and cycle over the whole data structure to execute operations. Each iteration consumes gas, which is why the amount of required gas for the overall function execution increases with each added element
# Problem
Out-of-gas exceptions can interrupt iterations over an unbounded iterable data structure (referred to as unbounded mass operations). Such mass oper-ations usually start from the first element of an array and run until all gas is consumed, which may lead to denial of service because certain elements at the end of the array will never be processed.
# Forces
In case of an exception thrown during the iteration over an unbounded data structure (e.g., due to an out-of-gas exception or a timeout), the iteration should be interrupted and be continuable with the next call.
# Solution
To avoid out-of-gas exceptions and continue an iteration over an unbounded, iterable data structure, developers should implement a mechanism to check if sufficient gas is available for the next iteration and an index variable that stores the index of the last element of the iteratable data structure that was successfully processed. When resuming the iteration over the unbounded data structure through another call of the smart contract function, the loop continues at the value stored in the index variable. If a procedure to be executed within the loop fails multiple times for a certain index, this failure should be marked to prevent denial of service and proceed with subsequent elements of the iterable data structure.
# Example
## Wrong
```Solidity
pragma solidity ^0.7.0;

contract IndexedLoopAntipattern {
    struct Payee {
        address payable addr;
        uint256 value;
    }
    
    Payee[] payees;

    receive() external payable {
        Payee memory p = Payee(msg.sender, msg.value);
        payees.push(p);
    }
    
    function payout() public {
        uint256 i = 0;
        while(i < payees.length) {
            // The require statement will block the loop
            // if an asset transfer always fails
            require(payees[i].addr.{value:payees[i].value}(),
                       "An error occured.");
            i++;
        }
    }
}

```
## Correct
```Solidity
pragma solidity ^0.7.0;

contract IndexedLoopPattern {
    struct Payee {
        address payable addr;
        uint256 value;
    }

    Payee[] payees;
    uint256 nextPayeeIndex;

    receive() external payable {
        Payee memory p = Payee(msg.sender, msg.value);
        payees.push(p);
    }

    function payout() public payable {
        uint256 totalGasConsumed = 0;
        // Amount of gas required for each iteration
        uint256 gasPerIteration = 42000;
        // Minimum amount of gas required to execute the code after the loop
        uint256 gasForPostLoopExecution = 1650;
        uint256 gasRequired = gasPerIteration + gasForPostLoopExecution;

        while(nextPayeeIndex < payees.length && gasleft() >= gasRequired
            && totalGasConsumed + gasRequired < block.gaslimit) {

            uint256 val = payees[nextPayeeIndex].value;
            payees[nextPayeeIndex].value = 0;
            payees[nextPayeeIndex].addr.send(val);
            totalGasConsumed = totalGasConsumed + gasPerIteration;
            nextPayeeIndex++;
        }
        
        if(nextPayeeIndex == payees.length)
             nextPayeeIndex = 0;
    }
}

```
The individual gas costs for _gasPerIteration_ and _gasForPostLoop_ have been manually calculated. The Indexed-Loop Pattern implemented in the above example assumes that all asset transfers succeed and **does not protect from wallet griefing**. To protect from wallet griefing, mechanisms to keep track of failed transactions and the corresponding recipient accounts must be implemented to adjust the index accordingly and prevent denial of service. For such checks, the return value of the asset transfer function in line 24 must be considered.

# Resulting Context
Before iterations over an unbounded data structure will exceed the available amount of gas, the iteration is aborted can be resumed in a subsequent invocation of the same function at the index stored in an index variable. To completely iterate over the data structure as intended, more than one call of the function might be necessary. Due to additional operations (e.g., updating the index variable), the use of the Indexed-Loop Pattern increases gas cost for deployment and execution. Furthermore, the user who triggers the iteration must pay all gas themselves.
# Rationale
By implementing an index variable that points to the last successfully processed element of the iterable data structure, the effects of an out-of-gas exceptions can be mitigated because operations that exceed the gas limit can be continued by the next function call
# Related Patterns
Pull Pattern
# Known Uses
FoMo3Dlong(lines 565 ff): https://etherscan.io/address/0xa62142888aba8370742be823c1782d17a0389da1