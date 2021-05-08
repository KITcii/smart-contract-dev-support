const tc = artifacts.require("ChecksEffectsInteractionsAntipattern");
const attacker_contract = artifacts.require('./Attacker.sol')

contract('ChecksEffectsInteractionsAntipattern', async (accounts) => {

    let victim;

    // Runs before all tests in this block.
    // Read about .new() VS .deployed() here:
    // https://twitter.com/zulhhandyplast/status/1026181801239171072
    before(async () => {
        victim = await tc.new();
    })

    it('TestContract balance should starts with 0 ETH', async () => {
        let balance = await web3.eth.getBalance(victim.address);
        assert.equal(balance, 0);
    })

    it('TestContract balance should has 11 ETH after deposit', async () => {
        let one_eth = web3.utils.toWei("11", "ether");
        await web3.eth.sendTransaction({from: accounts[1], to: victim.address, value: one_eth});
        let balance_wei = await web3.eth.getBalance(victim.address);
        let balance_ether = web3.utils.fromWei(balance_wei, "ether");
        assert.equal(balance_ether, 11);
    })

    it('Should be safe from Reentrancy', async () => {
        attacker = await attacker_contract.new(victim.address);
        console.log(await web3.eth.getBalance(victim.address));
        console.log(await web3.eth.getBalance(attacker.address));
        await attacker.set_balance();
        result = await attacker.attack();
        //console.log(result)
        console.log(await web3.eth.getBalance(victim.address));
        console.log(await web3.eth.getBalance(attacker.address));
    })    

})