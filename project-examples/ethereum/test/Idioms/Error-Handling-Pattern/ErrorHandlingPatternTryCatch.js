const ErrorHandlingPatternTryCatch = artifacts.require('ErrorHandlingPatternTryCatch');
const {expectEvent} = require('@openzeppelin/test-helpers');

contract('ErrorHandlingPatternTryCatch', async (accounts) => {

    before(async () => {
        contract = await ErrorHandlingPatternTryCatch.new();
    });

    it('Should catch error', async () => {
        const creation = await contract.createCharitySplitter(accounts[10], 1);
        await expectEvent(creation, 'ErrorHandled', {reason: "Creation not successful."});
    });
})
