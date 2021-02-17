pragma solidity 0.7.0;

contract ChecksEffectsInteractionsPattern {
    mapping (address => uint256) public balances;

    function withdraw(uint _amount) public{
        // Checks
        if(balances[msg.sender] >= _amount){
            // Effects
            balances[msg.sender] -= _amount;
            // Interaction
            (bool success,) = msg.sender.call{value: _amount}("");
            require(success);
        }
    }
}
