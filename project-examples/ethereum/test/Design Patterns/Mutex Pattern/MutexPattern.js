const MutexPattern = artifacts.require('MutexPattern');
const attacker_contract = artifacts.require('AttackerMutex');
const {expectRevert} = require('@openzeppelin/test-helpers');

contract('MutexPattern', async (accounts) => {
    let victim;
  
    before(async () => {
        victim = await MutexPattern.new();
    });

    it('MutexPattern balance should starts with 0 ETH', async () => {
        let balance = await web3.eth.getBalance(victim.address);
        assert.equal(balance, 0);
    });

    it('MutexPattern balance should have 11 ETH after deposit', async () => {
        const oneETH = web3.utils.toWei("1", "ether");

        for(let i=0; i<11; i++) {
            await web3.eth.sendTransaction({from: accounts[i], to: victim.address, value: oneETH});
        }

        const balanceWei = await web3.eth.getBalance(victim.address);
        const balanceETH = web3.utils.fromWei(balanceWei, "ether");
        assert.equal(balanceETH, 11);
    });

    it('MutexPattern should be safe from Reentrancy', async () => {
        // Create new attacker contract
        attacker = await attacker_contract.new(victim.address);
        
        // Send 1 ETH to the attacker contract
        // The attacker needs to have some balance at the exploitet contract
        const oneETH = web3.utils.toWei("1", "ether");
        await attacker.setBalance({from: accounts[11], value: oneETH});
        
        // We can now try to withdraw more than we initially send to the exploited contract
        await expectRevert(
            attacker.attack({from: accounts[11]}),
            "Transaction failed."
        );
    });
});
