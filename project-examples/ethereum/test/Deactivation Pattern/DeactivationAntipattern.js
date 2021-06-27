const DeactivationAntipattern = artifacts.require('DeactivationAntipattern.sol')

contract('DeactivationAntipattern', async (accounts) => {

    before(async () => {
        contract = await DeactivationAntipattern.new();
    })

    it('DeactivationAntipattern balance should starts with 0 ETH', async () => {
        console.log(await web3.eth.getBalance(contract.address));
        
        let balance = await web3.eth.getBalance(contract.address);
        assert.equal(balance, 0);
    })

})