pragma solidity 0.7.0;

contract GuardingAntipattern {
    address public owner = msg.sender;

    function changeOwner(address _newOwner) public
        returns(bool){
        owner = _newOwner;
        return true;    
    }
}
