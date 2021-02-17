# Context
To retrieve external data, smart contracts need to interact with external IT services outside the distributed ledger to retrieve real-world data.
# Problem
Smart contracts are restricted to the use of data stored on the distributed ledger, which may not be sufficient for several applications that, for example, require real-world data (e.g., for calculations or the validation of conditions).
# Forces
Regarding the data provision, high availability and reliability of external IT services must be given. For the smart contract execution, cost (setup and operational) and performance of the smart contract execution are important to be considered when integrating external IT services in a smart contract. Storage consumption on the distributed ledger should be low and only required data should be stored
# Solution
A Relay Contract should be implemented that manages the data supply for other smart contracts requiring external data (referred to as User Contract) and communicates to the external IT services (referred to as Oracles). To improve data reliability, the Oracles must first register with the Relay Contract before participating in the data provision. When a User Contract requires external data, the User Contract initiates a request on the Relay Contract. This request includes all query parameters and a callback function to be invoked after the data has been retrieved. The Relay Contract triggers an event passing the query parameters. The Oracles that have been notified by the event, produce the desired data output (if possible) and send a transaction carrying the requested data to the Relay Contract. After a certain time, the Relay Contract compares the received results of all Oracles and calls the callback function of the User Contract.

This solution should be enhanced by an incentive mechanism (e.g., rewarding Oracles with coins) to increase Oracle providers’ willingness to share their data and computational resources. A mechanism to discourage malicious behavior (e.g., sibyl attacks) should be put in place, such as a collateral to be deposited in the Relay Contract when registering the Oracle.
# Example
![Oracle](Oracle%20Pattern%20-%20On-Ledger%20Voting%20Oracle.png)  
Data feeds register their addresses with the Relay Contract and listen on a certain event triggered by the Relay Contract. The Relay Contract receives a request for external data from a User Contract and a callback function to be invoked after the data is retrieved. The User Contract specifies its request with arguments passed to the Relay Contract in an appro-priate format. The Relay Contract interprets the arguments and triggers the associated event queryData(…). Through the event, the Relay Contract passes the arguments specifying the query to all Oracles that listen to the queryData(…) event. The Oracles pass their responses for the request to the Relay Contract. The Relay Contract appends all responses of Registered Oracles to a list. To increase data reliability, the Relay Contract compares the Oracles’ responses and decides for a certain response, for example, the most often response. Next, the Relay Contract calls the callback(…) defined in the request(…)of the User Contract. Finally, the Relay Smart Contract empties the list of responses.

# Resulting Context
The Relay Contract returns requested data to the User Contract. However, Oracles must update the Relay Contract, which becomes costly over time, which is why the developers of a User Contract using the Relay Contract should agree on a payment structure to incentivize Oracles to honestly deliver data. In addition, finding consensus in a smart contract increases costs compared to finding consensus on queried data external from the distributed ledger. However, having most components on the distributed ledger increases availability and reliability of the data retrieval.
# Rationale
The oracle pattern enables developers to increase flexibility of using smart contracts. Since no states are changed when a smart contract retrieves data from the Relay Contract, this approach only causes costs when updating the Relay Contract with new data.
# Related Patterns
\-
# Known Uses
[DOS Network](https://drive.google.com/file/d/1Ea1z8hBaf3VkrR3nXG5jQHoXgHnN_3sx/view)
