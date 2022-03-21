const ReplayProtectionPattern = artifacts.require('ReplayProtectionPattern');
const {expectRevert} = require('@openzeppelin/test-helpers');


contract('ReplayProtectionPattern', async (accounts) => {
    before(async () => {
        alice = accounts[301];
        bob = accounts[302];
        contract = await ReplayProtectionPattern.new({from: alice});

    });

    it('Alice should start with 4 ether', async () => {
        const startAmount = web3.utils.toWei('4', 'ether');
        await web3.eth.sendTransaction({from: alice, to: contract.address, value: startAmount}); 
        assert.equal(startAmount, await contract.balances.call(alice))
    });

    it('Money Transfer should be possible', async () => {
        const amount = web3.utils.toWei('1', 'ether');
        let executionNonce = 0;
        let messageHash = web3.utils.soliditySha3(alice, bob, amount, contract.address, executionNonce)
        let signature = await web3.eth.sign(messageHash, alice);    // sign the mesage hash

        // From ECDSA Contract: If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept these malleable signatures as well.
        signature = signature.substr(0, 130) + (signature.substr(130) == "00" ? "1b" : "1c"); // v: 0,1 => 27,28
      
        await contract.transferTokens(alice,
            bob,
            amount,
            executionNonce,
            signature,
            {from: alice});

        assert.equal(amount, await contract.balances(bob));
    });


    it('Execution nonce can only be used once', async () => {
        const amount = web3.utils.toWei('1', 'ether');
        let executionNonce = 0;
        let messageHash = web3.utils.soliditySha3(alice, bob, amount, contract.address, executionNonce)
        let signature = await web3.eth.sign(messageHash, alice);    // sign the mesage hash
        signature = signature.substr(0, 130) + (signature.substr(130) == "00" ? "1b" : "1c"); // v: 0,1 => 27,28

        await expectRevert(
            contract.transferTokens(alice,
                bob,
                amount,
                executionNonce,
                signature,
                {from: alice}),
                "Invalid execution nonce!"
        );
    });

    it('Should work with updated execution nonce', async () => {
        const amount = web3.utils.toWei('1', 'ether');
        let executionNonce = 1;
        let messageHash = web3.utils.soliditySha3(alice, bob, amount, contract.address, executionNonce)
        let signature = await web3.eth.sign(messageHash, alice);    // sign the mesage hash
        signature = signature.substr(0, 130) + (signature.substr(130) == "00" ? "1b" : "1c"); // v: 0,1 => 27,28

        await contract.transferTokens(alice,
            bob,
            amount,
            executionNonce,
            signature,
            {from: alice});

        assert.equal(amount*2, await contract.balances(bob));

    });

});