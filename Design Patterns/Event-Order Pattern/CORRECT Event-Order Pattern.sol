pragma solidity >=0.5.0 <0.7.0;

contract TransitionCounter {
    uint256 transCounter = 0;

    modifier transitionCounting(uint256 nextTransNum){
         require(nextTransNum == transCounter,
                "Current smart contract state does not match targeted state.");
         transCounter += 1;
         _;
    }
}

contract EventOrder is TransitionCounter {

    function a(uint nextTransNum) public transitionCounting(nextTransNum) {
        // Code to be executed in a certain state
    }
}
