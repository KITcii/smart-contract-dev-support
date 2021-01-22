pragma solidity ^0.6.1;

contract ChildContract {
    address private owner;

    public ChildContract(address _owner) {
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
                charitySplitters[msg.sender] = newChildContract;
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
