pragma solidity ^0.6.0;

contract OverflowAntipattern {
    event loopCompleted(uint256 number);
    
    uint256 counter = 0;
    
    function runLoop() public {
        for (uint8 i=255; i < 258 ; i+1){
            // Your code
            counter += 1; 
            
            if (counter==260){
                break;
            }
        }
        
       emit loopCompleted (counter);
    }
}
