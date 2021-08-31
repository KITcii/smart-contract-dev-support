pragma solidity 0.7.0;

contract GuardingPattern {
    address public owner;

    event OwnerChanged(string message);

    constructor(){
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(owner == msg.sender, "Not authorized!");
        _;
    }

    function changeOwner(address _newOwner) public onlyOwner {
        owner = _newOwner;
        emit OwnerChanged("Change Succsessful");
    }
}
