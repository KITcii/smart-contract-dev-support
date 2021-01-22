pragma solidity >=0.6.0 <0.7.0;

contract ChecksEffectsInteractionsPattern {
    mapping (address => uint256) public balances;

    function withdraw(uint amount) public{
        // Checks
        if(balances[msg.sender] >= amount){
            // Effects
            balances[msg.sender] -= amount;
            // Interaction
            (bool success,) = msg.sender.call{value: amount}("");
            require(success);
        }
    }
}
