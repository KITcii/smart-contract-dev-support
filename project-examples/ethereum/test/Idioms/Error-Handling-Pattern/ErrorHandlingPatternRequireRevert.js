const ErrorHandlingPatternRequireRevert = artifacts.require('ErrorHandlingPatternRequireRevert');
const {expectRevert} = require('@openzeppelin/test-helpers');

contract('ErrorHandlingPatternRequireRevert', async (accounts) => {

    before(async () => {
        contract = await ErrorHandlingPatternRequireRevert.new();
    });

    it('Should send assets', async () => {
        const balanceBefore = await web3.eth.getBalance(accounts[15]);
        const amount = web3.utils.toWei("0.01", "ether");
        await contract.sendAssets(accounts[15], true, {value: amount});
        const balanceAfter = await web3.eth.getBalance(accounts[15]);
        assert.isAbove(Number(balanceAfter), Number(balanceBefore));
    });

    it('Should send assets more complex', async () => {
        const balanceBefore = await web3.eth.getBalance(accounts[15]);
        const amount = web3.utils.toWei("0.01", "ether");
        await contract.sendAssetsMoreComplex(accounts[15], true, {value: amount});
        const balanceAfter = await web3.eth.getBalance(accounts[15]);
        assert.isAbove(Number(balanceAfter), Number(balanceBefore));
    });


    it('Should detect errors', async () => {
        const amount = web3.utils.toWei("0.01", "ether");
        await expectRevert(
            contract.sendAssets(accounts[15], false, {value: amount}),
            "Asset transfer failed."
        ); 
    });


    it('Should detect errors more complex', async () => {
        const amount = web3.utils.toWei("0.01", "ether");
        await expectRevert(
            contract.sendAssetsMoreComplex(accounts[15], false, {value: amount}),
            "Asset transfer failed."
        ); 
    });


})
