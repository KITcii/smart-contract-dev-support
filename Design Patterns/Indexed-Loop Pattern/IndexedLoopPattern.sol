pragma solidity ^0.7.0;

contract IndexedLoopAntipattern {
    struct Payee {
        address payable addr;
        uint256 value;
    }
    
    Payee[] payees;

    receive() external payable {
        Payee memory p = Payee(msg.sender, msg.value);
        payees.push(p);
    }
    
    function payout() public {
        uint256 i = 0;
        //If call fails at reciever i because of an gas related issue
        
        while(i < payees.length) {
            // The require statement will block the loop if an asset transfer always fails
            (bool success, ) = payees[i].addr.call{value:payees[i].value}("");
            require(success, "An error occured.");
            payees[i].value = 0;
            i++;
        }    
            
    }
}
