const DeactivationAntipattern = artifacts.require('DeactivationAntipattern');
const {expectRevert} = require('@openzeppelin/test-helpers');

contract('DeactivationAntipattern', async (accounts) => {
    before(async () => {
        contract = await DeactivationAntipattern.new();
    });

    it('Should produce an error if deactivated and funds are send to it.', async () => {
        await contract.close();
        let oneEth = web3.utils.toWei("1", "ether");
        await web3.eth.sendTransaction({from: accounts[1], to: contract.address, value: oneEth});
       
        await expectRevert(
            web3.eth.sendTransaction({from: accounts[1], to: contract.address, value: oneEth}),
            expectRevert.unspecified
        );    
    });
})
