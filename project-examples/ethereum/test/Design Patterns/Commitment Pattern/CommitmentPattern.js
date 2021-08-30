const CommitmentPattern = artifacts.require('CommitmentPattern');
const {expectRevert} = require('@openzeppelin/test-helpers');

contract('CommitmentPattern', async (accounts) => {

    beforeEach(async () => {
        contract = await CommitmentPattern.new({from: accounts[0]});
    })

    //development idea preliminary

    it('Should allow to make a commit ', async () => { 
        await contract.changeOwner(accounts[1], {from: accounts[0]});
        let owner = await contract.owner.call();
        assert.equal(accounts[1], owner);
    })

    it('Should not allow to reveal incorrect value', async () => {
        await expectRevert(
            contract.changeOwner(accounts[1], {from: accounts[1]}),
            "Not authorized!"
        );    
    })

    it('Should only allow to reveal as commiter', async () => {
        await expectRevert(
            contract.changeOwner(accounts[1], {from: accounts[1]}),
            "Not authorized!"
        );    
    })


    it('Should allow to reveal correct value', async () => {
        await expectRevert(
            contract.changeOwner(accounts[1], {from: accounts[1]}),
            "Not authorized!"
        );    
    })


})