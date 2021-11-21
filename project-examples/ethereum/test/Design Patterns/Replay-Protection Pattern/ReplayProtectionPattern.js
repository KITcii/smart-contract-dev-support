const ReplayProtectionPattern = artifacts.require('ReplayProtectionPattern');
const {expectRevert} = require('@openzeppelin/test-helpers');

contract('ReplayProtectionPattern', async (accounts) => {
    before(async () => {
        contract = await ReplayProtectionPattern.new();
    });

    it('Should be possible to send money ', async () => {
        let amount = web3.utils.toWei('0.0001', 'ether');
        await contract.buyTokens({from: accounts[0], value: amount});
        await contract.buyTokens({from: accounts[1], value: amount});
        await contract.buyTokens({from: accounts[2], value: amount});

        const transferAmount = web3.utils.toWei('0.00001', 'ether');
        const executionNonce = 0;

        // const params = accounts[0].address + "" + accounts[1].address +"" + transferAmount + "" + executionNonce;
        const params = accounts[0] + "" + accounts[1] +"" + transferAmount + "" + executionNonce;
        const signedParams = await web3.eth.sign(params, accounts[0]);

        console.log(params);

        await contract.transferTokens(accounts[0],
            accounts[1],
            transferAmount,
            executionNonce,
            signedParams,
            {from: accounts[0]});

        assert.equal(amount, await contract.balances(accounts[0]));
    });
});