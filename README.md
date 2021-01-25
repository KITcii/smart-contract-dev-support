# Introduction
Developing smart contracts for distributed ledgers is currently a major challenge for developers because of the peculiarities of smart contracts, such as the requirement of concurrency between transactions attached to the distributed ledger, the requirement of determinism in the execution of smart contracts, the openness that allows arbitrary nodes to read transaction data in the DLT network and execute any smart contract stored in the distributed ledger, and the tamper resistance that prevents developers from fixing bugs as in traditional software development.

In order to make smart contract developers aware of the peculiarities of smart contracts and how to deal with these peculiarities, we present several software design patterns that we developed based on our findings from an extensive literature review and various expert interviews. The software design patterns comprise three levels of abstractions: architectural patterns, design patterns, and idioms. Architectural patterns, design patterns, and idioms. Architectural patterns describe “[…] a fundamental structural organization or scheme for software systems and provide a set of predefined subsystems, specify their responsibilities, and include rules and guidelines for organizing the relationships between them” [1, p. 12]. Design patterns provide “[…] a scheme for refining the subsystems or components of a software system, or the relationships between them” [1, p. 13] to solve a general design problem within a certain context. Idioms are patterns on the lowest level of abstraction and “describe[s] how to implement particular aspects of components or the relationships between them using the features of the given language” [1, p. 14].

As software development (especially in the area of smart contract development) is moving very fast, we encourage you to support us in maintaining this repository. With this in mind, we welcome open questions and comments on the identified challenges and corresponding solutions.

## Overview of Patterns

* [Architectural Patterns](Architectural%20Patterns/README.md#introduction)
  * [Façade Pattern](Architectural%20Patterns/Façade%20Pattern/README.md#context)
  * [Name
  Service Pattern](Architectural%20Patterns/Name-Service%20Pattern/README.md#context)
  * [Observer Pattern](Architectural%20Patterns/Observer%20Pattern/README.md#context)
  * [Oracle Pattern](Architectural%20Patterns/Oracle%20Pattern/README.md#context)
  * [Proxy Pattern](Architectural%20Patterns/Proxy%20Pattern/README.md#context)
* [Design Patterns](Design%20Patterns/README.md#introduction)
  * [Commitment Pattern](Design%20Patterns/Commitment%20Pattern/README.md#context)
  * [Event-Order Pattern](Design%20Patterns/Event-Order%20Pattern/README.md#context)
  * [Factory Pattern](Design%20Patterns/Factory%20Pattern/README.md#context)
  * [Indexed-Loop Pattern](Design%20Patterns/Indexed-Loop%20Pattern/README.md#context)
  * [Mutex Pattern](Design%20Patterns/Mutex%20Pattern/README.md#context)
  * [Pull Pattern](Design%20Patterns/Pull%20Pattern/README.md#context)
* [Idioms](Idioms/README.md#introduction)
  * [Checks-Effects-Interactions Pattern](Idioms/Checks-Effects-Interactions%20Pattern/README.md#context)
  * [Error-Handling Pattern](Idioms/Error-Handling%20Pattern/README.md#context)
  * [External-Call Pattern](Idioms/External-Call%20Pattern/README.md#context)
  * [Guarding Pattern](Idioms/Guarding%20Pattern/README.md#context)
  * [Overflow Pattern](Idioms/Overflow%20Pattern/README.md#context)
  * [Token Pattern](Idioms/Token%20Pattern/README.md#context)


# References
[1] F. Buschmann, Ed., Pattern-oriented software architecture: a system of pat-terns. Chichester ; New York: Wiley, 1996.
