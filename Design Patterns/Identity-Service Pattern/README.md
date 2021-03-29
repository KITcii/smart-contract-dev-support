# Identity-Service Pattern
## Context
The Identity-Service Pattern is applicable whenever digital identities and their associated pseudonyms should be managed in a decentralized manner. 

``Applies to: [X] EOSIO    [X] Ethereum    [ ] Hyperledger Fabric``

## Problem
The objective of the Identity-Service Pattern is to enable decentralized identity management to overcome challenges related to accountability and liability issues in distributed ledgers. The problem that the Identity-Service Pattern aims to solve is that on public distributed ledgers, such as Ethereum-based or EOSIO-based distributed ledgers, pseudonyms are often hard to associate with their corresponding real-world entity this may pose a challenge if certain aspects of an identity need to be known as prerequisite for a transaction.   

## Forces
The forces involved in the Identity-Service Pattern are accountability, liability, transparency and privacy. The Identity-Service Pattern enables the attestation of claims regarding the identity of a real-world entity (e.g., the age or address of an individual), this fosters transparency if certain prerequisites are required to proceed with a transaction. Furthermore, accountability and liability is enabled through linking the pseudonyms on the public distributed ledgers to their correspoding real-world entities. As drawback the privacy of the real-world entity is reduced.

## Solution
The Identity-Service Pattern is based on the concept of decentralized identity management systems using decentralized document identifiers (DIDs) that are stored on the distributed ledger. The DID points to a DID document that includes a statement about a DID subject (e.g., the age of an individual). The statement can be attested by verifiable claims issued by other users consisting of a claim and an attestation. The claim includes information about the validity of the statement whereas the attestation includes meta data and the digital signature of the user that issued the verifiable claim. Based on the verifiable claims the validity of a DID document and by extension the authenticity of the identity can be assumed.

## Example
![Identity-Service](IdentityService%20Pattern.png)


## Resulting Context
Pseudonyms used on public distributed ledgers can be linked to their identity or statements about their identity, this may introduce challenges related to the privacy and condfidentiality of the real-world identities that have been linked.

## Rationale
DIDs are stored on distributed ledgers and link to an DID document containing a statement about an real-world identity. The validity of the information is then assessed on basis of the aggregation of all verifiable claims issued. 

## Related Patterns
\-

## Known Uses
\-

