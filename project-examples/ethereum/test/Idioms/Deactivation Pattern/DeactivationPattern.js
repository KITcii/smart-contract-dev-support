const DeactivationPattern = artifacts.require('DeactivationPattern.sol');
const {expectRevert} = require('@openzeppelin/test-helpers');


contract('DeactivationPattern', async (accounts) => {

    before(async () => {
        contract = await DeactivationPattern.new();
    })

    it('Should produce an error if deactivated and funds are send to it.', async () => {
        await contract.setActive(false);
        let one_eth = web3.utils.toWei("1", "ether");

        await expectRevert(
            web3.eth.sendTransaction({from: accounts[1], to: contract.address, value: one_eth}),
            "Contract is deactivated"
        );
        
    })

})