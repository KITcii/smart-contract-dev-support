pragma solidity 0.7.0;

contract GuardingAntipattern {
    address public owner;

    event OwnerChanged(string message);

    constructor() {
        owner = msg.sender;
    }

    function changeOwner(address _newOwner) public {
        owner = _newOwner;
        emit OwnerChanged("Change Succsessful");  
    }
}
