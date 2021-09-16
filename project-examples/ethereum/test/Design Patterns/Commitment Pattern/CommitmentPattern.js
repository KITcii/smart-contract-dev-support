const CommitmentPattern = artifacts.require('CommitmentPattern');
const {expectRevert} = require('@openzeppelin/test-helpers');

contract('CommitmentPattern', async (accounts) => {
    before(async () => {
        contract = await CommitmentPattern.new({from: accounts[0]});
    });

    // Development idea preliminary
    it('Should allow to make a commit ', async () => { 
        const SecretValue = "Hello World!";
        const SecretSalt = "42";

        secret_commit = web3.utils.soliditySha3(SecretSalt+SecretValue);
        secret_salt = web3.utils.soliditySha3(web3.utils.toHex(SecretSalt));

        console.log(secret_commit);
        console.log(secret_salt);

        tx = await contract.commit(secret_commit, secret_salt);
    });

    it('Should not allow to reveal incorrect value', async () => {
        tx = await contract.reveal("Hello", "42");
        assert.equal(1,2);
    });

    it('Should only allow to reveal as commiter', async () => {
        await contract.reveal("Hello World!","42", {from: accounts[1]});
    });

    it('Should allow to reveal correct value', async () => {
        await contract.reveal("Hello World!","42");
        assert.equal(1,2);
    });
});
