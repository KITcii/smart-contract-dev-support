# Identity-Service Pattern
## Context
The Identity-Service Pattern applies to public DLT systems, where identities have pseudonyms, but additional identity attributes should be made available. 

``Applies to: [X] EOSIO    [X] Ethereum    [ ] Hyperledger Fabric``

## Problem
On public distributed ledgers, such as Ethereum or EOS, pseudonyms are a major attribute to reference identities in DLT systems. Still, several applications require additional identity attributes for appropriate functioning (e.g., a vehicle type in smart city applications for data trading). The Identity-Service Pattern enables decentralized identity management on distributed ledgers and allows for the estimation of the credibility of identity attributes using verifiable claims.

## Forces
The forces involved in the Identity-Service Pattern are confidentiality and transparency. The Identity-Service Pattern enables the decentralized attestation of identity attributes (e.g., the age or address of an individual), increasing transparency of checks regarding the fulfillment of certain application requirements. However, confidentiality of identity attributes included in DID documents is reduced.

## Solution
The Identity-Service Pattern is based on the concept of decentralized identity management systems using decentralized document identifiers (DIDs) that are stored in the distributed ledger. The DID stored in the Identity-Service Contract correspond to the hash value of a DID document that includes a statement about a DID subject (e.g., the age of an entity). The DID document is referenced in the smart contract (e.g., by storing an URI to access the DID document aside the DID). The contents of the DID document are attested by verifiable claims issued by other identities in the DLT system to the Identity-Service Contract. Verifiable claims comprise a claim and an attestation. The claim includes information about the validity of the attributes in the DID document, whereas the attestation includes meta data as well as the public key and the digital signature of the identity that issued the verifiable claim. To attest contents of a DID document, identities pass their individual claims, the digitally signed claims, their public keys, and their account names to the `attestClaim(…)` function in the Identity-Service Contract. The Identity-Service Contract verifies that the public key matches the digital signature and the account name and stores the arguments if the verification was successful.

To estimate the validity of contents in DID documents, identities use the statements included in issued verifiable claims. For the estimation, there are different strategies, such as calculating the average value of all claims (if the claims include numeric ratings) or only considering claims issued by identities with a public key that is already known by the identity estimating the validity of the DID document (e.g., due to prior transactions).

## Example
![Identity-Service](IdentityService%20Pattern.png)


## Resulting Context
Pseudonyms used on public distributed ledgers can be linked to DID documents and attributes of the corresponding identity can become credible. However, the Identity-Service Pattern strongly relies on the engagement of other identities for issuing verifiable claims. Otherwise, the credibility of the DID document cannot be estimated. Moreover, the Identity-Service Pattern is subject to the cold start problem. Only after a certain number of verifiable claims have been issued, the credibility of the DID document can be reasonably estimated.

## Rationale
DIDs are stored on distributed ledgers and link to an DID document that contains identity attributes. The credibility of the identity attributes is then estimated using verifiable claims issued by other identities.

## Related Patterns
[Factory Pattern](../../Design%20Patterns/Factory%20Pattern/README.md)

## Known Uses
\-

