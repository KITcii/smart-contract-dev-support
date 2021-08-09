const TokenAntipattern = artifacts.require('TokenAntipattern.sol');
const Token = artifacts.require('Token.sol')

contract('TokenAntipattern', async (accounts) => {

    before(async () => {

        contract = await TokenAntipattern.new();
    })

    it('Should be possible to change the Token contract', async () => { 
        

    })


})