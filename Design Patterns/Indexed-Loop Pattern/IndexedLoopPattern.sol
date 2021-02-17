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
        // Estimated amount of gas required for each iteration (must not be smaller than the actually consumed gas)
        uint256 gasPerIteration = 42000;
        // Minimum amount of gas required to execute the code after the loop
        uint256 gasForPostLoopExecution = 1650;
        uint256 gasRequired = gasPerIteration + gasForPostLoopExecution;

        while(nextPayeeIndex < payees.length && gasleft() >= gasRequired
            && totalGasConsumed + gasRequired < block.gaslimit) {

            uint256 val = payees[nextPayeeIndex].value;
            payees[nextPayeeIndex].value = 0;
            // Avoid transferring assets from within a loop because of untrustful external calls
            payees[nextPayeeIndex].addr.send(val);
            totalGasConsumed = totalGasConsumed + gasPerIteration;
            nextPayeeIndex++;
        }
        
        if(nextPayeeIndex == payees.length) {
             nextPayeeIndex = 0;
        }
    }
}
