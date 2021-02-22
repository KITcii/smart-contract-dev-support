# Proxy Pattern
## Context
When deploying a new smart contract, the smart contract gets a unique address assigned. To update a deployed smart contract, it must be redeployed. Functions of the smart contract are called by other applications (e.g., by another smart contract or user interface). The address of the smart contract changes due to the required redeployment of the smart contract after maintenance. After redeployment, the smart contract address must also be updated in all applications that are now to interact with the redeployed smart contract.

## Problem
Because of the public visibility of smart contract code and the integratability of smart contracts in arbitrary frontends, the need to update a smart contract address can hardly be communicated to all developers responsible for applications using the smart contract. Thus, several applications can still interact with a deprecated (and even destructed) smart contract version. Moreover, updating smart contract addresses in applications can flaw (e.g., by inserting the wrong address).

## Forces
The maintainability of a smart contract should be given without having to change its address in applications that call the smart contract. At the same time, the cost of executing smart contracts should not increase. No additional vulnerabilities should be caused by the solution.

## Solution
Deploy a Proxy Contract, which points to the latest version of the actual smart contract to be executed (referred to as Target Contract). All DLT applications (including other smart contracts) that interact with the Target Contract call the Proxy Contract instead of the Target Contract. The Proxy Contract stores the address of the latest version of the Target Contract and calls the intended function of the Target Contract. After the function of the Target Smart Contract has been executed, the Proxy Contract forwards the return of the Target Contract. To call the function of the Target Contract, the Proxy Contract implements identical function interfaces like the Target Contract (i.e., regarding function identifiers and parameters).
## Example

Wrong | Correct
------------- | -------------
![Wrong](Proxy%20Pattern%20-%20No%20Proxy.png)  | ![Correct](Proxy%20Pattern%20-%20Proxy.png)

## Resulting Context
The Proxy Pattern allows to maintain the original smart contract, while making it accessible via the static address of the Proxy Contract.

Drawbacks of this approach include that the data stored in a deprecated smart contract needs to be transferred to its later versions, which poses security risks, additional efforts, and costs. Furthermore, maintainers of the Proxy Contract may be fraudulent and may implement calls to a malicious smart contract instead of the Target Contract intended to be called.

The Proxy Pattern only helps for cases where the basic interface (i.e., function signatures and semantics) of the Target Contract does not change. Otherwise, it would still be necessary to update the User Application. In addition, the use of a Proxy Contract may pose an issue when using events triggered by the Target Contract because the Proxy Contract only triggers the Target Contract and receives its returned value. All operations in between these events can hardly be observed to trigger events.
## Rationale
Technically, the Target Contract still cannot be changed. Nevertheless, the interaction with the Target Contract is completely managed by the Proxy Contract, which keeps its static address and calls the respective function of the current version of the actual smart contract to be executed.
## Related Patterns
[Façade Pattern](/Architectural%20Patterns/Façade%20Pattern/README.md#context)
## Known Uses
[Unknown Contract](https://etherscan.io/bytecode-decompiler?a=0x09cabec1ead1c0ba254b09efb3ee13841712be14)
