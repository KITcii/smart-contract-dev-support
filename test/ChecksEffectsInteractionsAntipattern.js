const ChecksEffectsInteractionsAntipattern = artifacts.require("ChecksEffectsInteractionsAntipattern");

contract("ChecksEffectsInteractionsAntipattern", (accounts) => {
    let [alice, bob] = accounts;
    let contractInstance;
    before(async () => {
        const contractInstance = await ChecksEffectsInteractionsAntipattern.new({from: alice});
        //const contractInstance = await ChecksEffectsInteractionsAntipattern.new("0x0000000000000000000000000000000000000000", 900, alice, {from: accounts[alice]});
	        console.log(`Successfully deployed ChecksEffectsInteractionsAntipattern for Market Authority with address: ${contractInstance.address}`);
    });

    it("should be able to do something", async () => {
       //let result = await contractInstance.receive.value(10)({from: alice});
       //value optional test call
    //    const contractInstance = await ChecksEffectsInteractionsAntipattern.new({from: alice});
    //    let result = await web3.eth.sendTransaction({from: alice, to: contractInstance.address, value: 10000});

    //    assert.equal(result.receipt.status, true);

       //instance.sendTransaction({...}).then(function(result) {
        // Same transaction result object as above.
       // });

    })


})