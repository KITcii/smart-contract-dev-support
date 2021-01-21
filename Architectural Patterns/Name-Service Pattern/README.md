# Context
DLT applications and/or smart contracts call functions of other smart contracts, whose addresses may change over time because of maintenance and associated re-deployment. Consequently, the smart contract address must also be changed in all DLT applications and smart contracts that interact with these re-deployed smart contracts.
# Problem
It is challenging to find and always use the latest version of a smart contract in the presence of updates and changing smart contract addresses. In addition, smart contract addresses are hard to remember and not intuitive for developers, which decreases the intuitive interaction with smart contracts on the code level.
# Forces
The latest version of a smart contract should be easily retrievable. Furthermore, the interaction with a smart contract should become intuitive by not using smart contract addresses and function names.
# Solution
Register individual smart contracts with a Registry Contract that is publicly known. The registration associates a desired (but unambiguous) name to the smart contract address. To retrieve the latest version of a smart contract, the smart contract’s associated name should be passed as a parameter to a lookUpAddress(string name) function in the Registry Contract.

For maintenance of the Registry Contract, an authorization mechanism should be implemented, for example, that accounts are only authorized to update smart contracts they registered themselves. It is required to implement mechanisms that prevent duplicate or forbidden names and ambiguities.
# Example
Wrong | Correct
------------- | -------------
![Wrong](Name-Service%20Pattern%20-%20Direct%20Calls%20via%20Address.png)User application (or smart contract) directly calls functions of each smart contract using the direct address of each individual smart contract. | ![Correct](Name-Service%20Pattern%20-%20Calls%20via%20Name-Service.png)User application (or smart contract) first calls the Registry Contract to re-trieve the current smart contract address (and/or the targeted function sig-nature).

# Resulting Context
Smart contracts can retrieve the address of the latest version of a smart contract using intuitive names instead of addresses. In case a registered smart contract’s address changes, the associated entry can be centrally updated in the Registry Contract. Only the Registry Contract needs to be updated and all smart contracts relying on the Registry Contract will retrieve the address of the latest version of the smart contract. Nevertheless, the ability to update smart contract addresses decreases tamper-resistance and users of the Registry Contract must trust developers that the registered smart contracts will not be changed with malicious intention.
# Rationale
The registration contract serves as a dictionary that translates the names of smart contracts into the assigned address of their latest version.
# Related Patterns
* [Façade Pattern](/Architectural%20Patterns/Façade%20Pattern/README.md#context)
* [Proxy Pattern](/Architectural%20Patterns/Proxy%20Pattern/README.md#context)
# Known Uses
Ethereum Name Service: https://docs.ens.domains/