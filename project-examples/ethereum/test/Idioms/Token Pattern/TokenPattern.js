const TokenPattern = artifacts.require('TokenPattern.sol');
const Token = artifacts.require('Token.sol')

contract('TokenPattern', async (accounts) => {

    before(async () => {
        token_contract = await Token.new()
        logic_contract = await TokenPattern.new(token_contract.address);
    })

    it('Should be possible to change the Token contract', async () => { 
        //create new token contract
        new_token_contract = await Token.new();
        //set new token contract
        await logic_contract.changeToken(new_token_contract.address);
        //query address of token contract in use
        let result = await logic_contract.t.call()
        //assert that the change has worked
        assert.equal(new_token_contract.address, result);
    })

})