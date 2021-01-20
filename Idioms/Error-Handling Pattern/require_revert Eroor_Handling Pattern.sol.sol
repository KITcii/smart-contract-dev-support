pragma solidity 0.6.10;

contract Sharer {

    function sendAssets(address payable addr)
       public payable returns (bool) {
        require (!addr.call{value: (msg.value / 2)}(""),
                   "Asset transfer failed.");
        return true;
    }

    function sendAssetsMoreComplex(address payable addr)
       public payable returns (bool) {
        if(block.difficulty < 1000) {
            if(!addr.call{value: (msg.value / 2)}("")) {
                revert("Asset transfer failed.");
            } else {
                return true;
            }
        }      
        return true;
    }
}
