const IndexedLoopAntipattern = artifacts.require('IndexedLoopAntipattern');
const {expectRevert} = require('@openzeppelin/test-helpers');

contract('IndexedLoopAntipattern', async (accounts) => {
    before(async () => {
        contract = await IndexedLoopAntipattern.new();
    });

    it('Should be possible to send money ', async () => { 
        const amount = web3.utils.toWei("0.01", "ether");
        for(i = 0; i<=500; i++) {
            await web3.eth.sendTransaction({from: accounts[5], to: contract.address, value: amount});
        }
    });

    it('Payout possible', async () => { 
        const amount = web3.utils.toWei("0.01", "ether");

        await web3.eth.sendTransaction({from: accounts[6], to: contract.address, value: amount});

        balanceBegin = await web3.eth.getBalance(accounts[6]);
        balanceBegin = Number(balanceBegin);

        // make sure that all payouts have taken place
        await contract.payout({from: accounts[8]});
        await contract.payout({from: accounts[8]});

        balanceEnd = await web3.eth.getBalance(accounts[6]);
        balanceEnd = Number(balanceEnd);

        assert.isBelow(balanceBegin, balanceEnd);
       
    });
})
