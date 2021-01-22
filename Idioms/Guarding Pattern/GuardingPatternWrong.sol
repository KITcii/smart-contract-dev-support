pragma solidity >=0.5.0 <0.7.0;

contract NoAuthorizationCheck {
    address public owner = msg.sender;

    function changeOwner(address newOwner) public
        returns(bool){
        owner = newOwner;
        return true;    
    }
}
