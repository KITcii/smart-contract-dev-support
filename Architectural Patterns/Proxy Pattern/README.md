# Context
When deploying a new smart contract, the smart contract gets a unique address assigned. If a smart contract becomes deprecated and is updated, all DLT applications and smart contracts that call functions of the deprecated smart contract must accordingly update the address of the deprecated smart contract with the new address, which causes computational overhead and faults. For example, if a smart contract has not been updated, a denial of service may occur for this smart contract.
# Problem
Due to the tamper-resistance of distributed ledgers, maintenance of smart contracts requires mechanisms to deploy an updated version of a smart contract with the same interface. Instead of updating the address of the smart contract in all other smart contracts and/or DLT applications, the updated smart contract must still be executable the old address.
# Forces
Maintainability of a smart contract should be given without the need to change its address in DLT applications or smart contracts that call the smart contract.
# Solution
Deploy a Proxy Contract, which points to the latest version of the actual smart contract to be executed (referred to as Target Contract). All DLT applications (including other smart contracts) that interact with the Target Contract call the Proxy Contract instead of the Target Contract. The Proxy Contract stores the address of the latest version of the Target Contract and calls the intended function of the Target Contract. After the function of the Target Smart Contract has been executed, the Proxy Contract forwards the return of the Target Contract. To call the function of the Target Contract, the Proxy Contract implements identical function interfaces like the Target Contract (i.e., regarding function identifiers and parameters).
# Example

Wrong | Correct
------------- | -------------
![Wrong](Proxy%20Pattern%20-%20No%20Proxy.png)  | ![Correct](Proxy%20Pattern%20-%20Proxy.png)

# Resulting Context
The Proxy Pattern allows to maintain the original smart contract, while making it accessible via the static address of the Proxy Contract.

Drawbacks of this approach include that the data stored in a deprecated smart contract needs to be transferred to its later versions, which poses security risks, additional efforts, and costs. Furthermore, maintainers of the Proxy Contract may be fraudulent and may implement calls to a malicious smart contract instead of the Target Contract intended to be called.

The Proxy Pattern only helps for cases where the basic interface (i.e., function signatures and semantics) of the Target Contract does not change. Other-wise, it would still be necessary to update the User Application. In addition, the use of a Proxy Contract may pose an issue when using events triggered by the Target Contract because the Proxy Contract only triggers the Target Contract and receives its returned value. All operations in between these events can hardly be observed to trigger events.
# Rationale
Technically, the Target Contract still cannot be changed. Nevertheless, the interaction with the Target Contract is completely managed by the Proxy Contract, which keeps its static address and calls the respective function of the current version of the actual smart contract to be executed.
# Related Patterns
TODO
# Known Uses
https://etherscan.io/bytecode-decompiler?a=0x09cabec1ead1c0ba254b09efb3ee13841712be14