const EventOrder = artifacts.require('EventOrder');
const {expectRevert} = require('@openzeppelin/test-helpers');

contract('EventOrder', async (accounts) => {
    before(async () => {
        contract = await EventOrder.new();
    })

    it('Should allow to execute Function with the correct transaction number ', async () => { 
        await contract.a(1);
    })

    it('Should not allow to execute function again in the same transaction number ', async () => { 
        await expectRevert(
            contract.a(1),
            "Current smart contract state does not match targeted state."
        );
    })
})    
