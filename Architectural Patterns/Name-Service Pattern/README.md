# Name-Service Pattern
## Context
The Name-Service Pattern is applicable in the context of calling on other smart contracts via their addresses.

## Problem
The objective of the Name-Service Pattern is to simplify the reuse of other smart contracts through assign names to smart contracts. This solves a problem as smart contract addresses are difficult to remember, which limits intuitive interaction with smart contracts at the code level. It is also difficult for developers to find (the latest version of) already deployed smart contracts for integration into their own applications. The goal for the Name-Service Pattern is to enable easy discovery of the latest version of a smart contract for any developer using an intuitive name. Furthermore, the interaction with a smart contract should become intuitive by not using smart contract addresses and function names.

## Forces
The Name-Service Pattern contributes to the improvement of readibility and comprehensibility of smart contract code but comes at the cost of resource efficiency connected with the set up of a Register Contract.

## Solution
Register individual smart contracts with a Registry Contract that is publicly known. The registration associates a desired (but unambiguous) name to the smart contract address. To retrieve the latest version of a smart contract, the smart contract’s associated name should be passed as a parameter to a lookUpAddress(string name) function in the Registry Contract.

An authorization mechanism is implemented for the maintenance of the Registry Contract so that accounts are only authorized to update smart contract entries that they have registered themselves. Moreover, the Registry Contract prevents users from registering duplicate smart contracts, duplicate names forbidden names, and ambiguous names.
## Example
Wrong | Correct
------------- | -------------
![Wrong](Name-Service%20Antipattern_Wrong.png)User application (or smart contract) directly calls functions of each smart contract using the direct address of each individual smart contract. | ![Correct](Name-Service%20Pattern_Right.png)User application (or smart contract) first calls the Registry Contract to retrieve the current smart contract address (or the targeted function signature).

## Resulting Context
Smart contracts can retrieve the address of the latest version of a smart contract using intuitive names instead of addresses. In case a registered smart contract’s address changes, the associated entry can be centrally updated in the Registry Contract. Only the Registry Contract needs to be updated and all smart contracts relying on the Registry Contract will retrieve the address of the latest version of the smart contract. Nevertheless, the ability to update smart contract addresses decreases tamper-resistance and users of the Registry Contract must trust developers that the registered smart contracts will not be changed with malicious intention.
## Rationale
The registration contract serves as a dictionary that translates the names of smart contracts into the assigned address of their latest version.
## Related Patterns
\-
## Known Uses
[Ethereum Name Service](https://docs.ens.domains/)
