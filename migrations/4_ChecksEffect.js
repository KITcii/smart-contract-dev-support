const Victim = artifacts.require('./ChecksEffectsInteractionsPattern.sol')
const Attacker = artifacts.require('./Attacker2.sol')

module.exports = function(deployer) {
  deployer
    .deploy(Victim)
    .then(() =>
      deployer.deploy(Attacker, Victim.address)
    )
}