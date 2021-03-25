pragma solidity 0.7.0;

contract DeactivationAntipattern {
    function close() public onlyOwner { 
      selfdestruct(owner); 
    }
}
