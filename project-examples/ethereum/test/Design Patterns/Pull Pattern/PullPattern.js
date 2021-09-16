const PullPattern = artifacts.require('PullPattern');
const {expectEvent} = require('@openzeppelin/test-helpers');

contract('PullPattern', async (accounts) => {
    before(async () => {
        contract = await PullPattern.new();
    });

    it('Should be possible to send money ', async () => {
        const amount = web3.utils.toWei("0.00001", "ether");

        for (let i = 0; i < 500; i++) {
            await web3.eth.sendTransaction({from: accounts[i], to: contract.address, value: amount});
        }

        const balance = await contract.getBalance({from: accounts[499]});
        await expectEvent(balance, 'AccountBalance', {balance: amount + ''});
    });

    it('Payout possible', async () => {
        const balance = await contract.payout({from: accounts[499]});
        await expectEvent(balance, 'AccountBalance', {balance: '0'});
    });
});
