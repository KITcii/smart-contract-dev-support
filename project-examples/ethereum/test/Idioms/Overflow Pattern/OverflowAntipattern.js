const OverflowAntipattern = artifacts.require('OverflowAntipattern');
const {expectRevert} = require('@openzeppelin/test-helpers');

contract('OverflowAntipattern', async (accounts) => {

    beforeEach(async () => {
        contract = await OverflowAntipattern.new();
    })

    it('Should detect integer overflow', async () => { 
        await expectRevert(
            contract.runLoop(),
            "SafeMath: addition overflow"
        );    
    })


})