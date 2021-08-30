const CommitmentPattern = artifacts.require('CommitmentPattern');
const {expectRevert} = require('@openzeppelin/test-helpers');


contract('CommitmentPattern', async (accounts) => {

    before(async () => {
        contract = await CommitmentPattern.new({from: accounts[0]});
    })

    //development idea preliminary

    it('Should allow to make a commit ', async () => { 
        secret_commit = web3.utils.keccak256("Hello World!");
        secret_salt = web3.utils.keccak256("42");
        console.log(secret_salt);
        tx = await contract.commit(secret_commit, secret_salt);
        //console.log(tx);
        
    })

    it('Should not allow to reveal incorrect value', async () => {
        tx = await contract.reveal("Hello", "42");
    })

    it('Should only allow to reveal as commiter', async () => {
        await contract.reveal("Hello World!","42", {from: accounts[1]});
    })


    it('Should allow to reveal correct value', async () => {
        await contract.reveal("Hello World!","42");
    })


})