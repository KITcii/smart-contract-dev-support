pragma solidity 0.7.0;

contract ChecksEffectsInteractionsPattern {
    mapping (address => uint256) public balances;

    receive() external payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() public{
        uint _amount;
        _amount = 1 ether; 
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
