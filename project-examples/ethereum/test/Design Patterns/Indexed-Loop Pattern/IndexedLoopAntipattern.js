const IndexedLoopAntipattern = artifacts.require('IndexedLoopAntipattern');
const {expectRevert} = require('@openzeppelin/test-helpers');

contract('IndexedLoopAntipattern', async (accounts) => {
    before(async () => {
        contract = await IndexedLoopAntipattern.new();
    });

    it('Should be possible to send money ', async () => { 
        let amount = web3.utils.toWei("0.00001", "ether");

        for(i = 0; i<=500; i++) {
            await web3.eth.sendTransaction({from: accounts[0], to: contract.address, value: amount});
        }
    });

    it('Payout possible', async () => { 
       await contract.payout();
    });
})    
