const MutexAntipattern = artifacts.require('MutexAntipattern');
const attacker_contract = artifacts.require('AttackerAntiMutex');

contract('MutexAntipattern', async (accounts) => {

    let victim;
  
    before(async () => {
        victim = await MutexAntipattern.new();
    })

    it('MutexAntipattern balance should starts with 0 ETH', async () => {
        let balance = await web3.eth.getBalance(victim.address);
        assert.equal(balance, 0);
    })

    it('MutexAntipattern balance should have 11 ETH after deposit', async () => {
        let eleven_eth = web3.utils.toWei("11", "ether");
        await web3.eth.sendTransaction({from: accounts[1], to: victim.address, value: eleven_eth});
        let balance_wei = await web3.eth.getBalance(victim.address);
        let balance_ether = web3.utils.fromWei(balance_wei, "ether");
        assert.equal(balance_ether, 11);
    })

    it('MutexAntipattern should be safe from Reentrancy', async () => {
        
        // create new attacker contract
        attacker = await attacker_contract.new(victim.address);
        
        // send 1 ETH to the attacker contract
        const one_eth = web3.utils.toWei("1", "ether");
        // await web3.eth.sendTransaction({from: accounts[1], to: attacker.address, value: one_eth});
        
        
        // the attacker needs to have some balance at the exploitet contract
        await attacker.setBalance({value: one_eth});
        
        // we can now try to withdraw more than we initially send to the exploited contract
        result = await attacker.attack();
        
        // assert that the exploit has not worked
        assert.equal(one_eth, await web3.eth.getBalance(attacker.address));
    })    

})