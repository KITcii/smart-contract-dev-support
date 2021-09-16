const CommitmentPattern = artifacts.require('CommitmentPattern');
const {expectEvent} = require('@openzeppelin/test-helpers');
const {expectRevert} = require('@openzeppelin/test-helpers');

contract('CommitmentPattern', async (accounts) => {
    let contract;

    const secretValue = "Hello World!";
    const secretSalt = "42";

    const secretValueHash = web3.utils.soliditySha3(secretValue + secretSalt);
    const secretSaltHash = web3.utils.soliditySha3(secretSalt);

    const bytesValue = web3.utils.hexToBytes(secretValueHash);
    const bytesSalt = web3.utils.hexToBytes(secretSaltHash);

    before(async () => {
        contract = await CommitmentPattern.new({from: accounts[0]});
    });

    it('Should not allow to reveal values without prior commit', async () => {
        await expectRevert(
            contract.reveal("Hello", "42"),
            "You did not commit to a value."
        );
    });

    it('Should make a commit ', async () => {
        const c = await contract.commit(secretValueHash, secretSaltHash, {from: accounts[0]});
        await expectEvent(c, 'Commit', {value: secretValueHash, salt: secretSaltHash});
    });

    it('Should not allow to reveal with incorrect values', async () => {
        const reveal = await debug( contract.reveal("Hello", secretSalt,  {from: accounts[0]}) );
        await expectRevert(reveal, 'Invalid value.');
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
