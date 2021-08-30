const ReplayProtectionPattern = artifacts.require('ReplayProtectionPattern');
const {expectRevert} = require('@openzeppelin/test-helpers');

contract('ReplayProtectionPattern', async (accounts) => {

    before(async () => {
        contract = await ReplayProtectionPattern.new();
    })

    it('Should be possible to send money ', async () => { 
        let amount = web3.utils.toWei("2", "ether");
        await contract.buyTokens({from: accounts[0], value: amount}); 
        assert.equal(amount, await contract.balances(accounts[0]));   
    })

})    