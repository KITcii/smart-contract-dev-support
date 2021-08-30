const PullPattern = artifacts.require('PullPattern');
const {expectRevert} = require('@openzeppelin/test-helpers');

contract('PullPattern', async (accounts) => {

    before(async () => {
        contract = await PullPattern.new();
    })

    it('Should be possible to send money ', async () => { 
        let amount = web3.utils.toWei("0.00001", "ether");

        // we need accounts and not transactions
        for(i = 0; i<=2; i++) {
            //new_account = await web3.personal.newAccount()
            //await web3.eth.sendTransaction({from: new_account, to: contract.address, value: amount});
            await web3.eth.sendTransaction({from: accounts[0], to: contract.address, value: amount});
        }
    })

    it('Payout possible', async () => { 
       await contract.payout();
        
    })


})    