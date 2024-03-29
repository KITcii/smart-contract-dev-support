// SPDX-License-Identifier: MIT

pragma solidity 0.7.0;

import './LogicContract.sol';

contract TokenContract {
    address public owner;
    LogicContract logicContract;
    mapping(address => uint) public balances;

    event Sent(address from, address to, uint amount);
    event NewLogicContract(address newContract);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(owner == msg.sender, "Not authorized!");
        _;
    }

    receive() external payable {
        balances[msg.sender] += msg.value;
    }

    function setLogicContract(address _address) public onlyOwner {
        logicContract = LogicContract(_address);
        emit NewLogicContract(_address);
    }

    function send(address sender, address receiver, uint amount) public returns (bool) {
        require(msg.sender == address(logicContract), "Contract not authorized.");
        require(amount <= balances[sender], "Insufficient balance.");

        balances[msg.sender] -= amount;
        balances[receiver] += amount;

        emit Sent(msg.sender, receiver, amount);
        return true;
    }
}