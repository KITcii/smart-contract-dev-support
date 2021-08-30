# Name-Service Pattern
## Context
The Name-Service Pattern can be used to look up deployed smart contracts by their corresponding name.

``Applies to: [] EOSIO    [X] Ethereum    [] Hyperledger Fabric``

## Problem
In Ethereum, smart contract addresses are difficult to remember, which hinders intuitive interactions with smart contracts at the code level and finding smart contracts on-ledger. The aim of the Name-Service Pattern is to ease the discovery of the latest version of a smart contract using an intuitive name.

## Forces
The forces involved in the Name-Service Pattern are readability, code discoverability, and resource efficiency. The application of the Name-Service Pattern improves comprehensibility, particularly readability, by providing more intuitive names for interaction with other smart contracts than their addresses. Code discoverability is also increased as the latest version of a smart contract can be found in the Registry Contract. These improvements come at the cost of resource efficiency as the application of the Name-Service Pattern requires the deployment of an additional smart contract, the Registry Contract.

## Solution
Register individual smart contracts with a Registry Contract that is publicly known. The registration requires a desired (but unique) name to be associated with the smart contract address. To retrieve the latest version of a smart contract, the smart contract’s associated name can be passed as a parameter to a `lookUpAddress(string name)` function in the Registry Contract. The Registry Contract returns the current address of the searched smart contract or `null` if the name has not been registered with the Registry Contract.

An authorization mechanism should be implemented for the maintenance of the Registry Contract so that accounts are only authorized to update smart contract entries that they have registered themselves. Moreover, the Registry Contract prevents entities from registering duplicate smart contracts, duplicate names forbidden names, and ambiguous names.

## Example
Wrong | Correct
------------- | -------------
![Wrong](Name-Service%20Antipattern_Wrong.png)User application (or smart contract) directly calls functions of each smart contract using the direct address of each individual smart contract. | ![Correct](Name-Service%20Pattern_Right.png)User application (or smart contract) first calls the Registry Contract to retrieve the current smart contract address (or the targeted function signature).

## Resulting Context
Smart contracts can retrieve the address of the latest versions of smart contracts using intuitive names instead of addresses. If a registered smart contract’s address changes, the associated entry can be centrally updated in the Registry Contract. Only the Registry Contract needs to be updated and all smart contracts relying on the Registry Contract will retrieve the address of the latest version of the smart contract. Nevertheless, the ability to update smart contract addresses decreases tamper-resistance and entities using the Registry Contract must trust developers that the registered smart contract addresses will not be changed with malicious intention (e.g., to point to a smart contract that does not return once received assets). Registering smart contracts with the Registry Contracts causes costs to be paid by the identity registering a contract. Moreover, calls to the Registry Contract prior to actual calls to smart contracts consume additional time. The explained solution does not consider authorization mechanisms that guard the registration process and any identity can change once registered smart contract addresses.

## Rationale
The registration contract serves as a dictionary that translates the names of smart contracts into the assigned address of their latest version.

## Related Patterns
\-
## Known Uses
[Ethereum Name Service](https://docs.ens.domains/)
