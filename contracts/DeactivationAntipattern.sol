pragma solidity 0.7.0;

contract DeactivationAntipattern {
    function close() public { 
      selfdestruct(msg.sender); 
    }
}
