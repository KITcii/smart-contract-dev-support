# Smart Contract Development Support
This repository contains software design patterns to tackle frequent challenges in smart contract development. Each directory of a software design pattern includes a README.md file with a pattern description and code examples. Feel free to use the code example for your individual purposes.

We encourage you to support us in maintaining this repository and welcome your questions and comments on the software design patterns. To comment the software design patterns, please open an [issue](https://github.com/KITcii/smart-contract-dev-support/issues) or post your comment into the [discussion section](https://github.com/KITcii/smart-contract-dev-support/discussions).

## Overview of Software Design Patterns

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

# Structure of the Software Design Patterns

To make smart contract developers aware of the peculiarities of smart contracts and how to deal with these peculiarities, we present several software design patterns. The software design patterns comprise three levels of abstractions:

- _Architectural patterns_ describe “[…] a fundamental structural organization or scheme for software systems and provide a set of predefined subsystems, specify their responsibilities, and include rules and guidelines for organizing the relationships between them” [1, p. 12].

- _Design patterns_ provide “[…] a scheme for refining the subsystems or components of a software system, or the relationships between them” [1, p. 13] to solve a general design problem within a certain context.

- _Idioms are patterns_ on the lowest level of abstraction and “describe[s] how to implement particular aspects of components or the relationships between them using the features of the given language” [1, p. 14].

Each pattern is comprised of components to describe the pattern in a consistent and comprehensive manner. In this repository, we follow the _canonical form_ comprisong the following elements: 

- _Name:_ the pattern in one word "[…] to use a single word or short phrase to refer to the pattern, and the knowledge and structure it describes" [2, p. 5]. 

- _Problem:_ "[…] the goals and objectives [the developer] wants to reach within the given context and forces. Often the forces oppose these objectives as well as each other" [2, p. 5].

- _Context:_ "the preconditions under which the problem and its solution seem to recur, and for which the solution is desirable. This tells us the pattern's applicability" [2, p. 5].

- _Forces:_ "[…] the relevant forces and constraints and how they interact/conflict with one another and with goals we wish to achieve […]. Forces reveal the intricacies of a problem and define the kinds of trade-offs that must be considered in the presence of the tension or dissonance they create" [2, p. 5].

- _Solution:_ the "static relationships and dynamic rules describing how to realize the desired outcome. This is often equivalent to giving instructions which describe how to construct the necessary work products" [2, p. 5].

- _Examples:_ "one or more sample applications of the pattern which illustrate: a specific initial context; how the pattern is applied to, and transforms, that context; and the resulting context left in its wake" [2, p. 6].

- _Resulting Context:_ "the state or configuration of the system after the pattern has been applied, including the consequences (both good and bad) of applying the pattern, and other problems and patterns that may arise from the new context. It describes the postconditions and side-effects of the pattern" [2, p. 6].

- _Rationale:_ "a justifying explanation of steps or rules in the pattern, and also of the pattern as a whole in terms of how and why it resolves its forces in a particular way to be in alignment with desired goals, principles, and philosophies" [2, p. 6].

- _Related Patterns:_ "the static and dynamic relationships between this pattern and others within the same pattern language or system" [2, p. 6].

- _Known Uses_ are "[…] known occurrences of the pattern and its application within existing systems" [2, p. 6].

# References
[1] F. Buschmann, Ed., Pattern-oriented software architecture: a system of patterns. Chichester; New York: Wiley, 1996.  
[2] Appleton, Brad. Patterns and software: Essential concepts and terminology. 1997.
