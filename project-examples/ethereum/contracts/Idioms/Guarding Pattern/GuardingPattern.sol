pragma solidity 0.7.0;

contract GuardingPattern {
    address public owner;

    // Use a modifier to define your guarding conditions
    modifier onlyBy(address _account){
        require(owner == _account, "Not authorized!");
        _;
    }

    constructor(){
        owner = msg.sender;
    }


    function changeOwner(address _newOwner) public
        onlyBy(msg.sender){
        owner = _newOwner;
    }
}
