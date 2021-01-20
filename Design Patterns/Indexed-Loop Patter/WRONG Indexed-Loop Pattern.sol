pragma solidity >=0.5.0 <0.7.0;

contract WrongPayoutLoop {
    struct Payee {
        address payable addr;
        uint256 value;
    }
    
    Payee[]payees;

    receive() external payable {
        Payee memory p = Payee(msg.sender, msg.value);
        payees.push(p);
    }
    
    function payout() public {
        uint256 i = 0;
        while(i < payees.length) {
            // The require statement will block the loop
            // if an asset transfer always fails
            require(payees[i].addr.{value:payees[i].value}(),
                       "An error occured.");
            i++;
        }
    }
}
