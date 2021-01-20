pragma solidity >=0.5.0 <0.7.0;

contract AuthorizationCheck {
    address public owner = msg.sender;

    modifier onlyBy(address account){
        require(msg.sender == account, "Not authorized!");
        _;
    }

    function changeOwner(address newOwner) public
        onlyBy(owner){
        owner = newOwner;
    }
}
