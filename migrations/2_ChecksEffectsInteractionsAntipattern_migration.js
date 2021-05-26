const Victim = artifacts.require('ChecksEffectsInteractionsAntipattern.sol')
const Attacker = artifacts.require('Attacker.sol')

module.exports = function(deployer) {
  deployer
    .deploy(Victim)
    .then(() =>
      deployer.deploy(Attacker, Victim.address)
    )
}