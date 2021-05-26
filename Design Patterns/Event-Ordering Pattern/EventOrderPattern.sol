pragma solidity ^0.7.0;

contract EventOrderPattern {
    uint256 transCounter = 0;

    modifier transitionCounting(uint256 _nextTransNum){
         require(transCounter == _nextTransNum,
                "Current smart contract state does not match targeted state.");
         transCounter += 1;
         _;
    }
}

contract EventOrder is EventOrderPattern {

    function a(uint _nextTransNum) public transitionCounting(_nextTransNum) {
        // Code to be executed in a certain state
    }
}