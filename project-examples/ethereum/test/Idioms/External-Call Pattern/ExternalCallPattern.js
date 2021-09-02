const ExternalCallPattern = artifacts.require('ExternalCallPattern');
const ExternalContract = artifacts.require('ExternalContract');
const {expectRevert} = require('@openzeppelin/test-helpers');

contract('ExternalCallPattern', async (accounts) => {

    before(async () => {
        contract = await ExternalCallPattern.new();
        external_contract = await ExternalContract.new()
    })

    it('Should be able to make an external call', async () => { 
        tx = await contract.doSomething(external_contract.address, "Hello World", "Hello World");
    })

    it('Detect that no contract is at the specified address', async () => { 
        await expectRevert(
            contract.doSomething(accounts[5], "Hello World", "Hello World"),
            "Address does not point to a smart contract!"
        );
    })




})