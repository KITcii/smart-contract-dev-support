const LogicContract = artifacts.require('LogicContract');
const TokenContract = artifacts.require('TokenContract')

contract('LogicContract', async (accounts) => {
    let tokenContract;
    let logicContract;

    before(async () => {
        tokenContract = await Token.new()
        logicContract = await TokenPattern.new(tokenContract.address);
    });

    it('Should be possible to change the token contract', async () => {
        // Create new token contract
        newTokenContract = await Token.new();
        // Set new token contract
        await logicContract.changeToken(newTokenContract.address);
        // Query address of token contract in use
        const result = await logicContract.t.call()
        // Assert that the change has worked
        assert.equal(newTokenContract.address, result);
    });

    it('Should be possible to mint coins', async () => { 
        const amount = 5;
        await newTokenContract.mint(accounts[1], amount)

        const creditAccount1 = await newTokenContract.balances(accounts[1]);
        assert.equal(creditAccount1, amount);
    });
});
