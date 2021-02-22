# Name-Service Pattern
## Context
Functions of a smart contract are executed by other applications (e.g., by another smart contract or user interface). The address of the smart contract changes due to the required redeployment of the smart contract after maintenance. After redeployment, the smart contract address must also be updated in all applications that are now to interact with the redeployed smart contract.
## Problem
It is challenging to find and always use the latest version of a smart contract in the presence of updates and changing smart contract addresses. In addition, smart contract addresses are hard to remember and not intuitive for developers which decreases the intuitive interaction with smart contracts on the code level.
## Forces
The latest version of a smart contract should be easily retrievable. Furthermore, the interaction with a smart contract should become intuitive by not using smart contract addresses and function names.
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
