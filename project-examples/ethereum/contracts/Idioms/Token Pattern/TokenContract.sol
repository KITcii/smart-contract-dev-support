// SPDX-License-Identifier: MIT

pragma solidity 0.7.0;

import './LogicContract.sol';

contract TokenContract {
    address public owner;
    LogicContract logicContract;
    mapping(address => uint) public balances;

    event Sent(address from, address to, uint amount);

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
    }

    function send(address receiver, uint amount) public returns (bool) {
        require(msg.sender == address(logicContract), "Not authorized.");
        require(amount <= balances[msg.sender], "Insufficient balance.");

        balances[msg.sender] -= amount;
        balances[receiver] += amount;

        emit Sent(msg.sender, receiver, amount);
        return true;
    }

    function sendToEOA(address payable _account) public {
        require(msg.sender == address(logicContract), "Not authorized.");
        _account.transfer(balances[msg.sender]);
    }
}