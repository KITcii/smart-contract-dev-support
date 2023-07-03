# Oracle Pattern
## Context
A smart contract must interact with external services (i.e., oracles), for example, to retrieve off-ledger data or outsource computations.

``Applies to: [X] EOSIO    [X] Ethereum    [X] Hyperledger Fabric``
## Problem
Smart contracts on EOSIO-based and Ethereum-based blockchains are encapsulated and restricted to using data inherent to the distributed ledger, which may not be sufficient for applications that require real-world data. In smart contracts based on EOSIO, Ethereum, and Hyperledger Fabric, integrating oracles into smart contracts can cause dependencies to a third party operating the oracle, which can make the contract, for example, prone to fraud (e.g., when the oracle pushes malicious data) and decrease the availability of the services provided by the oracle. The goal of the Oracle Pattern is to enable interaction with oracles from smart contracts while considering potentially malicious actions of oracle providers.

## Forces
The forces involved in the Oracle Pattern are interoperability with external IT services and resource efficiency. The application of the Oracle Pattern enables interoperability with external systems by allowing access to external data. This comes at the cost of resource efficiency, because the Oracle Pattern requires the deployment and execution of additional smart contract code. 

## Solution
Implement a `RelayContract` that manages communication with oracles on behalf of one or more instances of a `UserContract`. Oracles register with the `RelayContract` (e.g., using their account address in Ethereum) and subscribe a listener to `RelayContract`. `UserContract` calls `RelayContract`, passing a request with required arguments. `RelayContract` triggers the registered oracles have subscribed, passing the request from `UserContract`. The oracles process the request and respond to `RelayContract`. To respond to requests from the `RelayContract`, each oracle sends a transaction with its response to `RelayContract`. `RelayContract` stores the individual answers for the request associated with the corresponding oracle identifier. After all registered oracles have responded to the request or a specified period has exceeded, `RelayContract` decides for a specific response to be forwarded to `UserContract`. For the decision, `RelayContract` can apply different rules (e.g., using the most frequent response). Subsequently, `RelayContract` passes the response to `UserContract` using the callback function passed by `UserContract` when making the request.

## Example
![Oracle](Oracle%20Pattern%20-%20On-Ledger%20Voting%20Oracle.png)  
Oracles register their accounts with `RelayContract` and subscribe to specified events triggered by `RelayContract`. `RelayContract` receives a request for external data from a `UserContract` and a callback function to be invoked after the data is retrieved. The `UserContract` specifies its request with arguments passed to `RelayContract` in an appropriate format. `RelayContract` interprets the arguments and triggers the associated event `queryData(…)`. Through the event, `RelayContract` passes the arguments specifying the query to all Oracles that listen to the `queryData(…)` event. The Oracles pass their responses for the request to `RelayContract`. `RelayContract` appends all responses of Registered Oracles to a list. To increase data reliability, `RelayContract` compares the Oracles’ responses and decides on a certain response, for example, the most often response. Next, `RelayContract` calls `callback(…)` defined in the `request(…)` triggered by `UserContract`. Finally, `RelayContract` empties the list of responses.

## Resulting Context
`RelayContract` forwards results returned by oracles to `UserContract`, which causes costs (e.g., due to the cost of gas in Ethereum). To cover the costs, developers of each `UserContract` that use a `RelayContract` should agree on a payment structure to compensate for transaction fees and incentivize oracle providers to provide data honestly.
By integrating multiple oracles and reaching consensus among their results, the likelihood of oracles succeeding with malicious actions (e.g., returning wrong data to `RelayContract`) decreases. However, finding consensus in `RelayContract` regarding the results to be forwarded to `UserContract` increases the on-ledger computational overhead. In DLT protocols that apply a pricing scheme for computational resource allocation (e.g., Ethereum), this computational overhead also increases cost for using `RelayContract`. Still, the fact that most of the components for the Oracle Pattern reside on the distributed ledger increases availability and reliability compared to systems that perform consensus finding regarding oracle responses off-ledger.

# Rationale
The Oracle Pattern enables developers to increase flexibility of smart contracts by interacting with services external to the distributed ledger. By engaging multiple oracles providing similar services, the Oracle Pattern prevents single points of failures and favors the detection of wrong or even malicious responses from oracles. 

# Related Patterns
\-
# Known Uses
[DOS Network](https://drive.google.com/file/d/1Ea1z8hBaf3VkrR3nXG5jQHoXgHnN_3sx/view)
