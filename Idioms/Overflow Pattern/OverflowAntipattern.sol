pragma solidity ^0.6.0;

contract OverflowAntipattern {
    event loopCompleted(uint256 number);
    
    uint256 counter = 0;
    
    function runLoop() public {
       for (uint8 i=0; i < 258 ; i+1){
           counter += 1; 
           // The following condition will never validate true
           if (counter==260){
               break;
           }
       }
        
       emit loopCompleted (counter);
    }
}
