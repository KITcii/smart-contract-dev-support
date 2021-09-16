const CommitmentPattern = artifacts.require('CommitmentPattern');
const {expectEvent} = require('@openzeppelin/test-helpers');
const {expectRevert} = require('@openzeppelin/test-helpers');

contract('CommitmentPattern', async (accounts) => {
    let contract;

    const secretValue = "Hello World!";
    const secretSalt = "42";

    const secretValueHash = '0xfcd21c4f942938771a1b3c27b33ddd26bb57cc79d3ae164893fd35998044ce10';
    const secretSaltHash = '0xd67ec9c49eb33d5d2b993016837392e45c1e14e4c66487a6d36c90205ac37e77';

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
        const commit = await contract.commit(secretValueHash, secretSaltHash, {from: accounts[0]});
        await expectEvent(commit, 'Commit', {value: secretValueHash, salt: secretSaltHash});

        const reveal = await contract.reveal(secretValue, secretSalt);
        await expectEvent(reveal, 'Reveal', {value: secretValueHash, salt: secretSaltHash});
    });

    it('Should not allow to reveal with incorrect values', async () => {
        await expectRevert(contract.reveal("Hello", secretSalt,  {from: accounts[0]}), 'Invalid values.');
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