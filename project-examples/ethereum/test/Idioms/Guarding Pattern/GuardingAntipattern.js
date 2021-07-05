const GuardingAntipattern = artifacts.require('GuardingAntipattern.sol');
const {expectRevert} = require('@openzeppelin/test-helpers');
const { each } = require('lodash');

contract('GuardingAntipattern', async (accounts) => {

    beforeEach(async () => {
        contract = await GuardingAntipattern.new({from: accounts[0]});
    })

    it('Should allow the owner to change the owner ', async () => { 
        contract.changeOwner(accounts[1], {from: accounts[0]});
        let owner = await contract.owner.call();
        assert.equal(accounts[1], owner);
    })

    it('Should not allow someone else to change the owner ', async () => {
        await expectRevert(
            contract.changeOwner(accounts[1], {from: accounts[1]}),
            "Not authorized!"
        );    
    })


})