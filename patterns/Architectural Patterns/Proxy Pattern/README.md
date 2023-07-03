# Proxy Pattern
## Context
An Ethereum smart contract is integrated into other systems (e.g., frontends or other smart contracts) and should be replaceable by a newer version in the future.

``Applies to: [] EOSIO    [X] Ethereum    [] Hyperledger Fabric``

## Problem
To update deployed Ethereum smart contracts, a new version of the smart contract must be deployed to the distributed ledger. Thereby, the address of the current smart contract version changes. To update the address accordingly, all systems that interact with the smart contract should be notified about the new address. Because of the public executability of smart contracts and unknown systems interacting with the updated smart contract, developers responsible for these systems can be, however, hardly notified. Thus, several systems may still interact with the deprecated (and even destructed) smart contract version. The aim of the Proxy Pattern is to circumvent challenges related to addressing changes due to smart contract updates so that the system integrating a smart contract must not update it after updates.

## Forces
The forces involved in the Proxy Pattern are maintainability, particularly code updatability and resource efficiency. The application of the Proxy Patterns improves the code updatability of smart contracts as the problems associated with the update and redeployment of existing smart contracts are circumvented. This comes at the cost of resource efficiency as an additional smart contract, the `ProxyContract`, which needs to be deployed and executed.

## Solution
Deploy a `ProxyContract` that points to the latest version of the smart contract to be executed (i.e., `TargetContract`). All systems that interact with the `TargetContract` call `ProxyContract` instead of the `TargetContract`. `ProxyContract` stores the address of the latest version of `TargetContract` and calls the intended `TargetContract`. After the Target Contract has been executed, `ProxyContract` forwards the returned values of `TargetContract`. To call the function of `TargetContract`, `ProxyContract` implements identical function interfaces like the `TargetContract`.

## Example

Wrong | Correct
------------- | -------------
![Wrong](Proxy%20Pattern%20-%20No%20Proxy.png)  | ![Correct](Proxy%20Pattern%20-%20Proxy.png)

## Resulting Context
The Proxy Pattern allows maintaining the original smart contract, while making it accessible via the static address of `ProxyContract`.

Drawbacks of this approach include that the data stored in a deprecated smart contract needs to be transferred to its later versions, which poses security risks, additional efforts, and costs. Furthermore, maintainers of `ProxyContract` may be fraudulent and may implement calls to a malicious smart contract instead of the `TargetContract` intended to be called.

The Proxy Pattern only applies when the basic interface (i.e., function signatures and syntax) of `TargetContract` does not change. In addition, using a `ProxyContract` may hinder the integration of events triggered by the `TargetContract` into a system because `ProxyContract` only triggers the `TargetContract` and receives its returned value.

## Rationale
Technically, the `TargetContract` still cannot be changed. Nevertheless, the interaction with the `TargetContract` is completely managed by the `ProxyContract`, which keeps its static address and calls the respective function of the current version of the actual smart contract to be executed.

## Related Patterns
[Façade Pattern](/Architectural%20Patterns/Façade%20Pattern/README.md#context)

## Known Uses
[ERC-725](https://github.com/ethereum/EIPs/issues/725)
[Unknown Contract](https://etherscan.io/bytecode-decompiler?a=0x09cabec1ead1c0ba254b09efb3ee13841712be14)
