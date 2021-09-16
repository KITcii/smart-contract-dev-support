const CommitmentPattern = artifacts.require('CommitmentPattern');
const {expectEvent} = require('@openzeppelin/test-helpers');
const {expectRevert} = require('@openzeppelin/test-helpers');

contract('CommitmentPattern', async (accounts) => {
    let contract;

    const secretValue = 'Hello World!';
    const secretSalt = 'this is a test salt'; //only string value possible in this example

    const secretValueHash = web3.utils.soliditySha3({t: 'string', v: secretValue}, {t: 'string', v: secretSalt});

    const encodedSalt = web3.eth.abi.encodeParameters(['string'],[secretSalt]);
    const secretSaltHash = web3.utils.sha3(encodedSalt, {encoding: 'hex'});

    before(async () => {
        contract = await CommitmentPattern.new({from: accounts[0]});
    });

    it('Should not allow to reveal values without prior commit', async () => {
        await expectRevert(
            contract.reveal("Hello", secretSalt),
            "You did not commit to a value."
        );
    });

    it('Should make a commit ', async () => {
        const commit = await contract.commit(secretValueHash, secretSaltHash, {from: accounts[0]});
        await expectEvent(commit, 'Commit', {value: secretValueHash, salt: secretSaltHash});

        const reveal = await contract.reveal(secretValue, secretSalt);
        await expectEvent(reveal, 'Reveal', {value: secretValueHash, salt: secretSaltHash});
    });

    it('Should not allow to reveal with incorrect values', async () => {
        await expectRevert(contract.reveal("Hello", secretSalt, {from: accounts[0]}), 'Invalid values.');
    });

    it('Should only allow to reveal as committer', async () => {
        const commit = await contract.reveal(secretValue, secretSalt, {from: accounts[0]});
        await expectEvent(commit, 'Reveal', {value: secretValueHash, salt: secretSaltHash});
    });

    it('Should only allow to reveal correct value', async () => {
        const reveal = await contract.reveal(secretValue, secretSalt);
        await expectEvent(reveal, 'Reveal', {value: secretValueHash, salt: secretSaltHash});
    });
});