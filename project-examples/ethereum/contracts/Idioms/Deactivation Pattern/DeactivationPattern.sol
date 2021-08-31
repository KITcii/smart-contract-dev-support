pragma solidity 0.7.0;

contract DeactivationPattern {
    address payable owner;
    bool activated = true; 

    constructor() {
      owner = msg.sender;
    }
    
    modifier checkActive(){
      require (activated, "Contract is deactivated");
      _;
    }

    modifier onlyOwner(){
        require (owner == msg.sender, "Not authorized");
        _;
    }

    receive() external payable checkActive {
    }
 
    function anyFunction() public checkActive {
      //code to be reverted by deactivation 
    }

    function setActive(bool _active) public onlyOwner{
      activated = _active;
    }

}