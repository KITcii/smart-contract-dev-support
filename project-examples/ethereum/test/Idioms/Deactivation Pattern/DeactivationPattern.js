const DeactivationPattern = artifacts.require('DeactivationPattern');
const {expectRevert} = require('@openzeppelin/test-helpers');


contract('DeactivationPattern', async (accounts) => {

    before(async () => {
        contract = await DeactivationPattern.new();
    });

    it('Should produce an error if deactivated and funds are send to it.', async () => {
        await contract.setActive(false);
        const oneEth = web3.utils.toWei("1", "ether");

        await expectRevert(
            web3.eth.sendTransaction({from: accounts[1], to: contract.address, value: oneEth}),
            "Contract is deactivated"
        ); 
    });
})
