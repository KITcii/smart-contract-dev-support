pragma solidity 0.6.10;

contract ErrorHandlingPatternRequireRevert {
    function sendAssets(address payable addr)
        public payable returns (bool) {
            (bool success, ) = addr.call{value: (msg.value / 2)}("");
            //hier stand ein Negationszeichen, falsch??
            require (success, "Asset transfer failed.");
            return true;
    }

    function sendAssetsMoreComplex(address payable addr)
        public payable returns (bool) {
            if(block.difficulty < 1000) {
                (bool success, ) = addr.call{value: (msg.value / 2)}("");
                if(!success) {
                    revert("Asset transfer failed.");
            } else {
                return true;
            }
            
            }      
            return true;
        }
}
