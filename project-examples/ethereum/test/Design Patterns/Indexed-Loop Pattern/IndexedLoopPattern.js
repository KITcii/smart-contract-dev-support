const IndexedLoopPattern = artifacts.require('IndexedLoopPattern');
const {expectEvent} = require('@openzeppelin/test-helpers');

contract('IndexedLoopPattern', async (accounts) => {
    before(async () => {
        contract = await IndexedLoopPattern.new();
    });

    it('Should be possible to send money', async () => {
        const amount = web3.utils.toWei('0.001', 'ether');
        for(i = 0; i<500; i++) {
            await web3.eth.sendTransaction({from: accounts[5], to: contract.address, value: amount});
        }
    });

    it('Payout possible', async () => {
        let balanceBegin = await web3.eth.getBalance(accounts[499]);
        balanceBegin = Number(balanceBegin);

        // Check if all payouts have taken place
        const txReceipt1 = await contract.payout({from: accounts[499]});
        await expectEvent(txReceipt1, 'ProgressTracker', {nextPayeeIndex: '295', numOfPayees: '500'});

        const txReceipt2 = await contract.payout({from: accounts[499]});
        await expectEvent(txReceipt2, 'ProgressTracker', {nextPayeeIndex: '0', numOfPayees: '500'});

        let balanceEnd = await web3.eth.getBalance(accounts[499]);
        balanceEnd = Number(balanceEnd);

        // Check if balanceBegin < balanceEnd to be sure that accounts[499] received tokens
        assert.isBelow(balanceEnd, balanceBegin);
    });
})
