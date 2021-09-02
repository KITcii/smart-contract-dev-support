const IndexedLoopPattern = artifacts.require('IndexedLoopPattern');
const {expectRevert} = require('@openzeppelin/test-helpers');
const { web3 } = require('@openzeppelin/test-helpers/src/setup');

contract('IndexedLoopPattern', async (accounts) => {
    before(async () => {
        contract = await IndexedLoopPattern.new();
    });

    it('Should be possible to send money ', async () => { 
        console.log(await web3.eth.getBalance(accounts[0]))
        let amount = web3.utils.toWei("1", "ether");
        for(i = 0; i<=500; i++) {
            await web3.eth.sendTransaction({from: accounts[0], to: contract.address, value: amount});
        }
        console.log(await web3.eth.getBalance(accounts[0]));
    });

    it('Payout possible', async () => { 
        console.log(await web3.eth.getBalance(accounts[0]));
        await contract.payout();
        console.log(await web3.eth.getBalance(accounts[0]));
        await contract.payout();
        console.log(await web3.eth.getBalance(accounts[0]));
       
    });
})
