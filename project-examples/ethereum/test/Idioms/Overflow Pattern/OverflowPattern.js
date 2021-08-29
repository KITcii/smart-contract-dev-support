const OverflowPattern = artifacts.require('OverflowPattern.sol');
const {expectRevert} = require('@openzeppelin/test-helpers');

contract('OverflowPattern', async (accounts) => {

    beforeEach(async () => {
        contract = await OverflowPattern.new();
    })

    it('Should detect integer overflow', async () => { 
        await expectRevert(
            contract.runLoop(),
            "SafeMath: addition overflow"
        );    
    })


})