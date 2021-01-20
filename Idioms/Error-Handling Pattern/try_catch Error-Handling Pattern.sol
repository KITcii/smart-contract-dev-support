pragma solidity ^0.6.1;
import "./CharitySplitter.sol";

contract CharitySplitterFactory {
    mapping (address => CharitySplitter) public charitySplitters;
    uint public errorCount;
    
    event ErrorHandled(string reason);

    function createCharitySplitter(address _charityOwner) public {
        try new CharitySplitter(_charityOwner)
            returns (CharitySplitter newCharitySplitter) { 
                charitySplitters[msg.sender] = newCharitySplitter;
        } catch Error(string memory reason) {
            errorCount++;
            CharitySplitter newCharitySplitter = new CharitySplitter(msg.sender);
            charitySplitters[msg.sender] = newCharitySplitter;
            // Emitting the error in event
            emit ErrorHandled(reason);
        } catch {
            errorCount++;
        }
    }
    
    // Your code
}
