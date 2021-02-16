# Introduction
Developing smart contracts for distributed ledgers is currently a major challenge for developers because of the peculiarities of smart contracts, such as the requirement of concurrency between transactions attached to the distributed ledger, the requirement of determinism in the execution of smart contracts, the openness that allows arbitrary nodes to read transaction data in the DLT network and execute any smart contract stored in the distributed ledger, and the tamper-resistance that prevents developers from fixing bugs as in traditional software development.

To make smart contract developers aware of the peculiarities of smart contracts and how to deal with these peculiarities, we present several software design patterns. The software design patterns comprise three levels of abstractions:

- _Architectural patterns_ describe “[…] a fundamental structural organization or scheme for software systems and provide a set of predefined subsystems, specify their responsibilities, and include rules and guidelines for organizing the relationships between them” [1, p. 12].

- _Design patterns_ provide “[…] a scheme for refining the subsystems or components of a software system, or the relationships between them” [1, p. 13] to solve a general design problem within a certain context.

- _Idioms are patterns_ on the lowest level of abstraction and “describe[s] how to implement particular aspects of components or the relationships between them using the features of the given language” [1, p. 14].

Each pattern is comprised of components to describe the pattern in a consistent and comprehensive manner. In this repository we follow the _canonical form_ which is comprised of the components: _Name, Problem, Context, Forces, Solution, Examples, Resulting Context, Rationale, Related Patterns_ and _Known Uses_ [2, p. 5, 6]. 

- _Name_ describes the pattern in one word and should be meaningful in order to allow us "[…] to use a single word or short phrase to refer to the pattern, and the
knowledge and structure it describes" [2, p. 5]. 

- _Problem_ describes "[…] its intent: the goals and objectives it wants to reach within the given context and forces. Often the forces oppose these objectives as well as each other" [2, p. 5].

- _Context_ describes "the preconditions under which the problem and its solution seem to recur, and for which the solution is desirable. This tells us the pattern's applicability" [2, p. 5].

- _Forces_ describe "[…] the relevant forces and constraints and how they interact/conflict with one another and with goals we wish to achieve […]. Forces reveal the intricacies of a problem and define the kinds of trade-offs that must be considered in the presence of the tension or dissonance they create" [2, p. 5].

- _Solution_ describes the "static relationships and dynamic rules describing how to realize the desired outcome. This is often equivalent to giving instructions which describe how to construct the necessary work products" [2, p. 5].

- _Examples_ are "one or more sample applications of the pattern which illustrate: a specific initial context; how the pattern is applied to, and transforms, that context; and the resulting context left in its wake" [2, p. 6].

- _Resulting Context_ describes "the state or configuration of the system after the pattern has been applied, including the consequences (both good and bad) of applying the pattern, and other problems and patterns that may arise from the new context. It describes the postconditions and side-effects of the pattern" [2, p. 6].

- _Rationale_ is "a justifying explanation of steps or rules in the pattern, and also of the pattern as a whole in terms of how and why it resolves its forces in a particular way to be in alignment with desired goals, principles, and philosophies" [2, p. 6].

- _Related Patterns_ describes "the static and dynamic relationships between this pattern and others within the same pattern language or system" [2, p. 6].

- _Known Uses_ are "[…] known occurrences of the pattern and its application within existing systems" [2, p. 6].

As software development (especially in the area of smart contract development) is moving very fast, we encourage you to support us in maintaining this repository. With this in mind, we welcome open questions and comments on the identified challenges and corresponding solutions.

## Overview of Patterns

* [Architectural Patterns](Architectural%20Patterns/README.md)
  * [Façade Pattern](Architectural%20Patterns/Façade%20Pattern/README.md)
  * [Name
  Service Pattern](Architectural%20Patterns/Name-Service%20Pattern/README.md)
  * [Observer Pattern](Architectural%20Patterns/Observer%20Pattern/README.md)
  * [Oracle Pattern](Architectural%20Patterns/Oracle%20Pattern/README.md)
  * [Proxy Pattern](Architectural%20Patterns/Proxy%20Pattern/README.md)
* [Design Patterns](Design%20Patterns/README.md)
  * [Commitment Pattern](Design%20Patterns/Commitment%20Pattern/README.md)
  * [Event-Order Pattern](Design%20Patterns/Event-Order%20Pattern/README.md)
  * [Factory Pattern](Design%20Patterns/Factory%20Pattern/README.md#context)
  * [Indexed-Loop Pattern](Design%20Patterns/Indexed-Loop%20Pattern/README.md)
  * [Mutex Pattern](Design%20Patterns/Mutex%20Pattern/README.md)
  * [Pull Pattern](Design%20Patterns/Pull%20Pattern/README.md)
* [Idioms](Idioms/README.md#introduction)
  * [Checks-Effects-Interactions Pattern](Idioms/Checks-Effects-Interactions%20Pattern/README.md)
  * [Error-Handling Pattern](Idioms/Error-Handling%20Pattern/README.md)
  * [External-Call Pattern](Idioms/External-Call%20Pattern/README.md)
  * [Guarding Pattern](Idioms/Guarding%20Pattern/README.md)
  * [Overflow Pattern](Idioms/Overflow%20Pattern/README.md)
  * [Token Pattern](Idioms/Token%20Pattern/README.md)


# References
[1] F. Buschmann, Ed., Pattern-oriented software architecture: a system of patterns. Chichester; New York: Wiley, 1996.
[2] Appleton, Brad. Patterns and software: Essential concepts and terminology. 1997.
