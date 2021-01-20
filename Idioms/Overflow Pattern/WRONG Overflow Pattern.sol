pragma solidity ^0.6.0;

library SafeMath8 {
    // Customized SafeMath for uint8
    function add(uint8 a, uint8 b) internal pure
      returns (uint8) {
        uint8 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }
}

contract NoOverflow {
    using SafeMath8 for uint8;
       
    function runLoop() public {
        for(uint8 i=255; i < 300 ; i+1{
            // Your code
        }
    }
