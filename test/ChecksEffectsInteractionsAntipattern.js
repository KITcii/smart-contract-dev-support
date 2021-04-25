const ChecksEffectsInteractionsAntipattern = artifacts.require("ChecksEffectsInteractionsAntipattern");
contract("ChecksEffectsInteractionsAntipattern", (accounts) => {
    let [alice, bob] = accounts;
    let contractInstance;
    beforeEach(async () => {
        const contractInstance = await ChecksEffectsInteractionsAntipattern.new();
    });

    it("should be able to do something", async () => {
       const result = await contractInstance.receive({from: alice});
       assert.equal(result.receipt.status, true);
    })
})