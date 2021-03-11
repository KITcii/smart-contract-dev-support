pragma solidity 0.7.0;

contract DeactivationPattern {
    function close() public onlyOwner { 
      selfdestruct(owner); 
    }
}
