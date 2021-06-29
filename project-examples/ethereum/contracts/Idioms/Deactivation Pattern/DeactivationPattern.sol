pragma solidity 0.7.0;

contract DeactivationPattern {
    
    bool _activated = true; 
    
    modifier checkActive(){
      require (_activated);
      _;
    }


    // This is only for demonstration purposes.
    // Everyone is able to deactivate your smart contract.
    function deactivate() public{
      _activated = false;
    }
    
    function anyFunction() checkActive public {
      //code to be reverted by deactivation 
    }

    fallback() checkActive external payable {
    }
}