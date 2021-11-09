const LogicContract = artifacts.require('LogicContract');
const TokenContract = artifacts.require('TokenContract');
const {expectEvent} = require('@openzeppelin/test-helpers');
const {expectRevert} = require('@openzeppelin/test-helpers');

contract('LogicContract', async (accounts) => {

    before(async () => {
        const amount = web3.utils.toWei("0.01", "ether");
        token = await TokenContract.new()
        logic = await LogicContract.new(token.address, amount);
        await token.setLogicContract(logic.address);
    });

    it('The Logic Should work', async () => {
        const amount = web3.utils.toWei("0.01", "ether");
        await web3.eth.sendTransaction({from: accounts[5], to: token.address, value: amount});
        const buyEvent = await logic.buy({from: accounts[5]});
        await expectEvent(buyEvent, 'ItemSold', {value: amount});
    });    
        
    it('Should detect Insufficient Funds', async () => {
        await expectRevert(
            logic.buy({from: accounts[4]}),
            "Insufficient Funds"
        );
    });

    it('Change Logic Contract ', async () => {
        const amountTwo = web3.utils.toWei("0.2", "ether");
        logicTwo = await LogicContract.new(token.address, amountTwo);
        const change = await token.setLogicContract(logicTwo.address);
        await expectEvent(change, 'NewLogicContract', {newContract: logicTwo.address});     
    });

    it('Old price should not be applicable', async () => {
        const amount = web3.utils.toWei("0.01", "ether");
        await web3.eth.sendTransaction({from: accounts[6], to: token.address, value: amount});
        await expectRevert(
            logic.buy({from: accounts[6]}),
            "Contract not authorized."
        );
    });

    it('Logic in the new contract should work', async () => {
        const amountTwo = web3.utils.toWei("0.2", "ether");
        await web3.eth.sendTransaction({from: accounts[7], to: token.address, value: amountTwo});
        const buyEvent = await logicTwo.buy({from: accounts[7]});
        await expectEvent(buyEvent, 'ItemSold', {value: amountTwo});
    });    




});
