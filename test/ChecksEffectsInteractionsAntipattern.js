const ChecksEffectsInteractionsAntipattern = artifacts.require("ChecksEffectsInteractionsAntipattern");
contract("ChecksEffectsInteractionsAntipattern", (accounts) => {
    let [alice, bob] = accounts;
    it("should be able to do something", async () => {
        const contractInstance = await ChecksEffectsInteractionsAntipattern.new();

        
    })
})