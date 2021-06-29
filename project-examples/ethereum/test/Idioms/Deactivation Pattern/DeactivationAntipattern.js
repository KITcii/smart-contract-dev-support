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


    it('DeactivationAntipattern balance should have 1 ETH after deposit', async () => {
        let one_eth = web3.utils.toWei("1", "ether");
        await web3.eth.sendTransaction({from: accounts[1], to: contract.address, value: one_eth});
        let balance_wei = await web3.eth.getBalance(contract.address);
        let balance_ether = web3.utils.fromWei(balance_wei, "ether");
        assert.equal(balance_ether, 1);
    })


    it('DeactivationAntipattern should not waste funds', async () => {
        await contract.close();
        
        
        let one_eth = web3.utils.toWei("1", "ether");
        await web3.eth.sendTransaction({from: accounts[1], to: contract.address, value: one_eth});
       
        let balance_wei = await web3.eth.getBalance(contract.address);
        let balance_ether = web3.utils.fromWei(balance_wei, "ether");
        assert.equal(balance_ether, 1);
    })


})