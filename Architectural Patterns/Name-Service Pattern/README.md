# Name-Service Pattern
## Context
The Name-Service Pattern can be used to look up deployed smart contracts by their corresponding name.

``Applies to: [] EOSIO    [X] Ethereum    [] Hyperledger Fabric``

## Problem
In Ethereum, smart contract addresses are difficult to remember, which limits intuitive interaction with smart contracts at the code level. the interaction with a smart contract should become intuitive by not using smart contract addresses. The aim of the Name-Service Pattern is to ease the discovery of the latest version of a smart contract using an intuitive name.

## Forces
The forces involved in the Name-Service Pattern are readability, code discoverability, semantic soundness, and resource efficiency. The application of the Name-Service Pattern improves comprehensibility particularly readability by providing more intuitive names for interaction with other smart contracts than their addresses. Code discoverability is also increased as the latest version of a smart contract can be found in the Registry Contract. Thus, semantic soundness is increased as calls to deprecated or destroyed smart contracts are prevented. These improvements come at the cost of resource efficiency as the application of the Name-Service Pattern requires the deployment of an additional smart contract, the Registry Contract.

## Solution
Register individual smart contracts with a Registry Contract that is publicly known. The registration associates a desired (but unambiguous) name to the smart contract address. To retrieve the latest version of a smart contract, the smart contract’s associated name should be passed as a parameter to a lookUpAddress(string name) function in the Registry Contract.

An authorization mechanism should be implemented for the maintenance of the Registry Contract so that accounts are only authorized to update smart contract entries that they have registered themselves. Moreover, the Registry Contract prevents entities from registering duplicate smart contracts, duplicate names forbidden names, and ambiguous names.

## Example
Wrong | Correct
------------- | -------------
![Wrong](Name-Service%20Antipattern_Wrong.png)User application (or smart contract) directly calls functions of each smart contract using the direct address of each individual smart contract. | ![Correct](Name-Service%20Pattern_Right.png)User application (or smart contract) first calls the Registry Contract to retrieve the current smart contract address (or the targeted function signature).

## Resulting Context
Smart contracts can retrieve the address of the latest version of a smart contract using intuitive names instead of addresses. In case a registered smart contract’s address changes, the associated entry can be centrally updated in the Registry Contract. Only the Registry Contract needs to be updated and all smart contracts relying on the Registry Contract will retrieve the address of the latest version of the smart contract. Nevertheless, the ability to update smart contract addresses decreases tamper-resistance and entities using the Registry Contract must trust developers that the registered smart contracts will not be changed with malicious intention.

## Rationale
The registration contract serves as a dictionary that translates the names of smart contracts into the assigned address of their latest version.

## Related Patterns
\-
## Known Uses
[Ethereum Name Service](https://docs.ens.domains/)
