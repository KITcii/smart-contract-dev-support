// SPDX-License-Identifier: MIT

pragma solidity 0.7.0;

contract OverflowAntipattern {
    uint256 internal counter = 0;

    event Overflow(uint256 iterationCounter);

    function runLoop() public {
        for (uint8 i = 255; i < 256; i + 1) {
            counter += 1;

            if (counter == 260) {
                break;
            }
        }

        emit Overflow(counter);
    }
}
