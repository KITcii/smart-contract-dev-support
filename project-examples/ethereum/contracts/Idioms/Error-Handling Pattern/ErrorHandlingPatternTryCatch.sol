pragma solidity 0.7.0;

//based on: https://blog.ethereum.org/2020/01/29/solidity-0.6-try-catch/

contract CharitySplitter {
    address public owner;

    constructor (address _owner, uint _successParameter) public {
        require(_owner != address(0), "No owner provided.");
        require(_successParameter == 0, "Creation not successful.");
        owner = _owner;
    }
}

contract ErrorHandlingPatternTryCatch {
    mapping (address => CharitySplitter) public charitySplitters;
    uint public errorCount;

    event ErrorHandled(string reason);

    function createCharitySplitter(address _childOwner, uint _successParameter) public {
        try new CharitySplitter(_childOwner,  _successParameter)
            returns (CharitySplitter newCharitySplitter) {
                charitySplitters[msg.sender] = newCharitySplitter;
        } catch Error(string memory reason) {
            errorCount++;
            CharitySplitter newCharitySplitter = new CharitySplitter(msg.sender, _successParameter);
            charitySplitters[msg.sender] = newCharitySplitter;
            // Emit the error event
            emit ErrorHandled(reason);
        } catch {
            errorCount++;
        }
    }
}
