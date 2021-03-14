# Replay-Protection Pattern

## Context
The Replay-Protection Pattern is applicable whenever the payload of a transaction can be replayed for repeated function execution, for example, after a hardfork of a distributed ledger.

``Applies to: [X] EOSIO    [X] Ethereum    [] Hyperledger Fabric``

## Problem
The objective of the Replay-Protection Pattern is to secure smart contracts from replay attacks that can, for example, perform unauthorized asset transfers.

## Forces
The forces involved are semantic soundness and resource efficiency. Semantic soundness can be improved by preventing replay attacks and, thus, improving robustness of the smart contract. However, the Replay-Protection Pattern requires additional checks that increase resources consumption.

## Solution
Add a digital signature to the paramaters to be passed to the function. Using the digital signature, all other function parameters and a nonce are signed to make their integrity provable and authenticate the identity that must authorize the function execution. The nonce to be passed is determined by the smart contract and changes after each function call. Only if the digital signature is valid, the function will be executed.

## Example
``Todo``

## Resulting Context
Whenever a function protected by the Replay-Protection Pattern is called, the signature sent with the call must match the signature of the passed parameters and the current nonce. The nonce is changed after each function call, which is why the function call is only successfull once. All other calls will be denied.

## Rationale
By using nonce in a digital signature that changes after each function call, the digital signature can be used only once. Subsequent function calls with the same digital signature become invalid.

## Related Patterns
\-

## Known Uses
[IdentityContract](https://github.com/B2E2/b2e2_contracts/blob/master/contracts/IdentityContract.sol) (lines 94ff)
