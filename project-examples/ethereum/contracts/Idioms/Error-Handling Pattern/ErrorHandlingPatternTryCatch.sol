pragma solidity 0.7.0;

//based on: https://blog.ethereum.org/2020/01/29/solidity-0.6-try-catch/

contract CharitySplitter {
    address public owner;

    event CreationSuccessful(string message);

    constructor (address _owner, uint _successParameter) {
        require(_owner != address(0), "No owner provided.");
        require(_successParameter == 0, "Creation not successful.");
        owner = _owner;
        emit CreationSuccessful('Contract created');
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
            // Simulate new succesful creation
            CharitySplitter newCharitySplitter = new CharitySplitter(msg.sender, 0);
            charitySplitters[msg.sender] = newCharitySplitter;
            // Emit the error event
            emit ErrorHandled(reason);
        } catch {
            errorCount++;
        }
    }
}
