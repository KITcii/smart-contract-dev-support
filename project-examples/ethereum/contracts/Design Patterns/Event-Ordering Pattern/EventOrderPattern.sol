// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

contract EventOrderPattern {
    uint256 transCounter = 0;

    modifier transitionCounting(uint256 _currentTransNumber){
         require(transCounter == _currentTransNumber,
                "Current smart contract state does not match current transaction number.");
         transCounter += 1;
         _;
    }
}

contract EventOrder is EventOrderPattern {
    event TransactionOccured(uint256 transNum);

    function a(uint _currentTransNumber) public transitionCounting(_currentTransNumber) {
        // Code to be executed in a certain state
        emit TransactionOccured(transCounter);
    }
}