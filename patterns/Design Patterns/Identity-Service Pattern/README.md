# Identity-Service Pattern
## Context
The Identity-Service Pattern applies to public DLT systems when attributes of digital identities need to be verifiable in a decentralized manner. 

``Applies to: [X] EOSIO    [X] Ethereum    [ ] Hyperledger Fabric``

## Problem
On public distributed ledgers, such as Ethereum or EOS, pseudonyms are hard to associate with their corresponding real-world entities. The Identity-Service Pattern enables decentralized identity management to overcome challenges related to accountability and liability issues in distributed ledgers.

## Forces
The forces involved in the Identity-Service Pattern are accountability, confidentiality, liability, transparency. The Identity-Service Pattern enables the attestation of claims regarding the identity of a real-world entity (e.g., the age or address of an individual), this fosters transparency if certain prereq-uisites are required to proceed with a transaction. Furthermore, accountability and liability are enabled through linking the pseudonyms on the public distributed ledgers to their corresponding real-world entities. As drawback the confidentiality of information about real-world entities associated with a pseudonym is reduced.

## Solution
The Identity-Service Pattern is based on the concept of decentralized identity management systems using decentralized document identifiers (DIDs) that are stored on the distributed ledger. The DID points to a DID document that includes a statement about a DID subject (e.g., the age of an entity). The statement can be attested by verifiable claims issued by other identities in the DLT system comprising a claim and an attestation. The claim in-cludes information about the validity of the statement whereas the attestation includes meta data and the digital signature of the user that issued the verifiable claim. Based on the verifiable claims the validity of a DID document and by extension the authenticity of the identity can be assumed.

## Example
![Identity-Service](IdentityService%20Pattern.png)


## Resulting Context
Pseudonyms used on public distributed ledgers can be linked to their identity or statements about their identity. The likability can introduce challeng-es related to the confidential treatment of data about real-world entities.

## Rationale
DIDs are stored on distributed ledgers and reference DID documents that contain attributes and statements about real-world entities. The validity of the attributes and statements is assessed based on the aggregation of all verifiable claims associated with the respective DID document.

## Related Patterns
[Factory Pattern](../../Design%20Patterns/Factory%20Pattern/README.md)

## Known Uses
\-

