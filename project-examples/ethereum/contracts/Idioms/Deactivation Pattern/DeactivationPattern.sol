pragma solidity 0.7.0;

contract DeactivationPattern {
    
    bool activated = true; 
    
    modifier checkActive(){
      require (activated, "Contract is deactivated");
      _;
    }


    // This is only for demonstration purposes.
    // Everyone is able to deactivate your smart contract.
    function deactivate() public{
      activated = false;
    }
    
    function anyFunction() checkActive public {
      //code to be reverted by deactivation 
    }

    fallback() checkActive external payable {
    }
}