const LogicContract = artifacts.require('LogicContract');
const TokenContract = artifacts.require('TokenContract')

contract('LogicContract', async (accounts) => {

    before(async () => {
        token_contract = await TokenContract.new()
        logic_contract = await LogicContract.new(token_contract.address);
    })

    it('Should be possible to change the Token contract', async () => { 
        //create new token contract
        new_token_contract = await token_contract.new();
        //set new token contract
        await logic_contract.changeTokenContract(new_token_contract.address);
        //query address of token contract in use
        let result = await logic_contract.t.call()
        //assert that the change has worked
        assert.equal(new_token_contract.address, result);
    })

    it('Should be possible to mint coins', async () => { 
        let amount = 5;
        await new_token_contract.mint(accounts[1], amount)

       let credit_account1 = await new_token_contract.balances(accounts[1]);
       assert.equal(credit_account1, amount);
    })


})