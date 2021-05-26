const Victim2 = artifacts.require('./ChecksEffectsInteractionsPattern.sol')
const Attacker2 = artifacts.require('./Attacker2.sol')

module.exports = function(deployer) {
  deployer
    .deploy(Victim2)
    .then(() =>
      deployer.deploy(Attacker2, Victim2.address)
    )
}