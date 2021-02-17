pragma solidity 0.7.0;

contract ChecksEffectsInteractionsAntipattern {
    mapping (address => uint256) public balances;

    function withdraw(uint amount) public{
        // Checks
        if(balances[msg.sender] >= _amount){
            // Interactions
            (bool success,) = msg.sender.call{value: _amount}("");
            require(success);
            // Effects
            balances[msg.sender] -= _amount;
        }
    }
}
