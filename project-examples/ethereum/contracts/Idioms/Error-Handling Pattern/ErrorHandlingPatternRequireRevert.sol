// SPDX-License-Identifier: MIT

pragma solidity 0.7.0;

contract ErrorHandlingPatternRequireRevert {
    function sendAssets(address payable _addr, bool _successParameter)
        public payable returns (bool) {
            (bool success, ) = _addr.call{value: (msg.value / 2)}("");

            // Simulate error
            if (_successParameter == false) {
                success = false;
            }

            require (success, "Asset transfer failed.");
            return true;
    }

    function sendAssetsMoreComplex(address payable _addr, bool _successParameter)
        public payable returns (bool) {
            if(block.difficulty < 1000) {
                (bool success, ) = _addr.call{value: (msg.value / 2)}("");
                
                // Simulate error
                if (_successParameter == false) {   
                success = false;
                }

                if(!success) {
                    revert("Asset transfer failed.");
                } else {
                    return true;
                }
            }      
            return true;
     }
}
