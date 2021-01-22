pragma solidity >=0.5.0 <0.7.0;

contract FunctionGuarding {
    address public owner = msg.sender;

    // Use a modifier to define your guarding conditions
    modifier onlyBy(address account){
        require(msg.sender == account, "Not authorized!");
        _;
    }

    function changeOwner(address newOwner) public
        onlyBy(owner){
        owner = newOwner;
    }
}
