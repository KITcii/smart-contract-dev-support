pragma solidity 0.7.0;

contract DeactivationPattern {
    bool _activated = true; 
    
    modifier checkActive(){
      require (_activated);
      _;
    }
    
    function anyFunction() checkActive public {
      //code to be reverted by deactivation 
    }
}