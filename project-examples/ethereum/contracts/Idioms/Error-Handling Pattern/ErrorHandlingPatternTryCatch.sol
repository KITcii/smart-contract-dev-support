pragma solidity 0.7.0;

contract ChildContract {
    address private owner;

    constructor (address _owner) public {
        owner = _owner;
    }
}

contract ErrorHandlingPatternTryCatch {
    mapping (address => ChildContract) public childContracts;
    uint public errorCount;
    
    event ErrorHandled(string reason);

    function createCharitySplitter(address _childOwner) public {
        try new ChildContract(_childOwner)
            returns (ChildContract newChildContract) {
                childContracts[msg.sender] = newChildContract;
        } catch Error(string memory reason) {
            errorCount++;
            ChildContract newChildContract = new ChildContract(msg.sender);
            childContracts[msg.sender] = newChildContract;
            // Emit the error event
            emit ErrorHandled(reason);
        } catch {
            errorCount++;
        }
    }
}
