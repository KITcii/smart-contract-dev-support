pragma solidity >=0.6.0 <0.7.0;

// This smart contract is vulnerable to reentrancy

contract ChecksEffectsInteractionsAntipattern {
    mapping (address => uint256) public balances;

    function withdraw(uint amount) public{
        // Checks
        if(balances[msg.sender] >= amount){
            // Interactions
            (bool success,) = msg.sender.call{value: amount}("");
            require(success);
            // Effects
            balances[msg.sender] -= amount;
        }
    }
}
