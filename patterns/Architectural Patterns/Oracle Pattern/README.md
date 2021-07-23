# Oracle Pattern
## Context
A smart contract must interact with external services (i.e., oracles), for example, to retrieve off-ledger data or outsource computations.

``Applies to: [X] EOSIO    [X] Ethereum    [X] Hyperledger Fabric``
## Problem
Smart contracts on EOSIO-based and Ethereum-based blockchains are encapsulated and restricted to using data inherent to the distributed ledger, which may not be sufficient for applications that require real-world data. In smart contracts based on EOSIO, Ethereum, and Hyperledger Fabric, integrating oracles into smart contracts can cause dependencies to a third party operating the oracle which can make the contract, for example, prone to fraud (e.g., when the oracle pushes malicious data) and decrease availability of the services provided by the oracle. The goal of the Oracle pattern is to enable interaction with oracles from smart contracts while taking into account potentially malicious actions of oracle providers.

## Forces
The forces involved in the Oracle Pattern are interoperability with external IT services and resource efficiency. The application of the Oracle Pattern enables interoperability with external systems by allowing access to external data. This comes at the cost of resource efficiency as the Oracle Pattern requires the deployment and execution of additional smart contract code. 

## Solution
Implement a Relay Contract that manages communication with oracles on behalf of one or more User Contracts. Oracles register with the Relay Contract (e.g., using their account address in Ethereum) and subscribe a listener to the Relay Contract. User Contracts call the Relay Contract, passing a request with required arguments. The Relay Contract triggers the even registered oracles have subscribed to, passing the request from the User Contract. The oracles process the request and respond to the Relay Contract. To respond to requests from the Relay Contract, each oracle sends a transaction with its response to the Relay Contract. The Relay Contract stores the individual answers for the request associated with the corresponding oracle identifier. After all registered oracles have responded to the request or a specified period has exceeded, the Relay Contract performs decides for a specific response to be forwarded to the User Contract. For the decision, the Relay Contract can apply different rules (e.g., using the most frequent response). Subsequently, the Relay Contract passes the response to the User Contract using the callback function passed by the User Contract when making the request.

## Example
![Oracle](Oracle%20Pattern%20-%20On-Ledger%20Voting%20Oracle.png)  
Data feeds register their addresses with the Relay Contract and listen on a certain event triggered by the Relay Contract. The Relay Contract receives a request for external data from a User Contract and a callback function to be invoked after the data is retrieved. The User Contract specifies its request with arguments passed to the Relay Contract in an appropriate format. The Relay Contract interprets the arguments and triggers the associated event queryData(…). Through the event, the Relay Contract passes the arguments specifying the query to all Oracles that listen to the queryData(…) event. The Oracles pass their responses for the request to the Relay Contract. The Relay Contract appends all responses of Registered Oracles to a list. To increase data reliability, the Relay Contract compares the Oracles’ responses and decides for a certain response, for example, the most often response. Next, the Relay Contract calls the callback(…) defined in the request(…)of the User Contract. Finally, the Relay Smart Contract empties the list of responses.

## Resulting Context
The Relay Contract forwards results returned by oracles to the User Contract, which causes costs (e.g., due to the cost of gas in Ethereum). To cover the costs, developer of User Contracts that use a Relay Contract should agree on a payment structure to compensate for transaction fees and incentivize oracle providers to provide data honestly.
By integrating multiple oracles and reaching consensus among their results, the likelihood of oracles succeeding with malicious actions (e.g., returning wrong data to the Relay Contract) decreases. However, finding consensus in the Relay Contract regarding the results to be forwarded to the User Contract increases the on-ledger computational overhead. In DLT protocols that apply a pricing scheme for computational resource allocation (e.g., Ethereum), this computational overhead also increases cost for using the Relay Contract. Still, the fact that most of the components for the Oracle Pattern reside on the distributed ledger increases availability and reliability compared to systems that perform consensus finding regarding oracle responses off-ledger.

# Rationale
The Oracle Pattern enables developers to increase flexibility of smart contracts by interacting with services external the distributed ledger. By engaging multiple oracles providing similar services, the Oracle Pattern prevents single points of failures and favors the detection of wrong or even malicious responses from oracles. 

# Related Patterns
\-
# Known Uses
[DOS Network](https://drive.google.com/file/d/1Ea1z8hBaf3VkrR3nXG5jQHoXgHnN_3sx/view)
