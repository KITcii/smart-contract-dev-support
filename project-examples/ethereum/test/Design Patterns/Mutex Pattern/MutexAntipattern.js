const MutexAntipattern = artifacts.require('MutexAntipattern');
const attacker_contract = artifacts.require('AttackerAntiMutex');

contract('MutexAntipattern', async (accounts) => {
    let victim;
  
    before(async () => {
        victim = await MutexAntipattern.new();
    });

    it('MutexAntipattern balance should starts with 0 ETH', async () => {
        const balance = await web3.eth.getBalance(victim.address);
        assert.equal(balance, 0);
    });

    it('MutexAntipattern balance should have 11 ETH after deposit', async () => {
        const elevenEth = web3.utils.toWei("11", "ether");
        await web3.eth.sendTransaction({from: accounts[1], to: victim.address, value: elevenEth});
        const balanceWei = await web3.eth.getBalance(victim.address);
        const balanceEther = web3.utils.fromWei(balanceWei, "ether");
        assert.equal(balanceEther, 11);
    });

    it('MutexAntipattern should be safe from Reentrancy', async () => {
        // Create new attacker contract
        attacker = await attacker_contract.new(victim.address);
        
        // Send 1 ETH to the attacker contract
        const oneEth = web3.utils.toWei("1", "ether");
        // await web3.eth.sendTransaction({from: accounts[1], to: attacker.address, value: one_eth});
       
        // The attacker needs to have some balance at the exploitet contract
        await attacker.setBalance({value: oneEth});
        
        // We can now try to withdraw more than we initially send to the exploited contract
        await attacker.attack();
        
        // Assert that the exploit has not worked
        assert.equal(oneEth, await web3.eth.getBalance(attacker.address));
    });
})
