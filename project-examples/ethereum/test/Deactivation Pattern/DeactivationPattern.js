const DeactivationPattern = artifacts.require('DeactivationPattern.sol')

contract('DeactivationPattern', async (accounts) => {

    before(async () => {
        contract = await DeactivationPattern.new();
    })

    it('DeactivationPattern balance should starts with 0 ETH', async () => {
        console.log(await web3.eth.getBalance(contract.address));

        let balance = await web3.eth.getBalance(contract.address);
        assert.equal(balance, 0);
    })


})