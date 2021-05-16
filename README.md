# Smart Contract Development Support
This repository contains software design patterns to address common challenges in the development of smart contracts, which we have identified in close collaboration with [EnBW Energie Baden-Württemberg AG](https://www.enbw.com/). Each directory of a software design pattern includes a `README.md` file with a [pattern description](#structure-of-the-software-design-patterns) and code examples. Feel free to use the code examples for your individual purposes.

We encourage you to support us in maintaining this repository and welcome your questions and comments on the software design patterns. To comment the software design patterns, please open an [issue](https://github.com/KITcii/smart-contract-dev-support/issues) for specific feedback on a software design pattern or post your general comments into the [discussion section](https://github.com/KITcii/smart-contract-dev-support/discussions).

## Quickstart Test Setup
We have created a few tests for our patterns.
### Setup
Install Truffle and Ganache

Launch Ganache:

    npx ganache-cli -l 1000000000
    
Start Truffle Test.
    truffle test     

## Overview of Software Design Patterns

### Architectural Patterns
[Architectural Patterns](Architectural%20Patterns/README.md) | Usage | EOSIO | Ethereum | Hyperledger Fabric
-------- | -------- | :-: | :-: | :-:
[Façade Pattern](Architectural%20Patterns/Façade%20Pattern/README.md) | Enable secure orchestration of smart contract systems | &#x2611; | &#x2611; |
[Name-Service Pattern](Architectural%20Patterns/Name-Service%20Pattern/README.md) | Create registry for smart contracts to assign intuitive names to smart contracts  | | &#x2611;  |
[Observer Pattern](Architectural%20Patterns/Observer%20Pattern/README.md) |Automate communication of address changes due to updates in smart contracts  | |&#x2611;  |
[Oracle Pattern](Architectural%20Patterns/Oracle%20Pattern/README.md) |Enable access to external data for smart contracts |&#x2611; |&#x2611;  |&#x2611;
[Proxy Pattern](Architectural%20Patterns/Proxy%20Pattern/README.md) |Enable code updatability of smart contract | |&#x2611;  |

### Design Patterns
[Design Patterns](Design%20Patterns/README.md) | Usage | EOSIO | Ethereum | Hyperledger Fabric
-------- | -------- | :-: | :-: | :-:
[Commitment Pattern](Design%20Patterns/Commitment%20Pattern/README.md) |Allow for binding commitment of values, which may remain secret until all values are to be revealed |&#x2611; |&#x2611; |&#x2611;
[Event-Ordering Pattern](Design%20Patterns/Event-Ordering%20Pattern/README.md) | Ensure a transaction is only executed in a certain smart contract state |&#x2611; |&#x2611; |&#x2611;
[Factory Pattern](Design%20Patterns/Factory%20Pattern/README.md#context) |Enable automatic redeployment of similar smart contracts  | |&#x2611;  |
[Identity-Service Pattern](Design%20Patterns/Identity-Service%20Pattern/README.md) |Enable decentralized identity management |&#x2611;  |&#x2611;  |
[Indexed-Loop Pattern](Design%20Patterns/Indexed-Loop%20Pattern/README.md) |Ensure an unbounded data structure can be interrupted and continued with the next call |&#x2611;  |&#x2611;  |
[Mutex Pattern](Design%20Patterns/Mutex%20Pattern/README.md) |Prevent reentrancy attacks | | &#x2611;  |
[Pull Pattern](Design%20Patterns/Pull%20Pattern/README.md) |Prevent abortion of execution caused by unbounded data structure and ensure fair distribution of costs|  | &#x2611;  |
[Replay-Protection Pattern](Design%20Patterns/Replay-Protection%20Pattern/README.md)|Prevent variable overflow caused by unappropriate data type use | |&#x2611; |

### Idioms
[Idioms](Idioms/README.md#introduction) | Usage | EOSIO | Ethereum | Hyperledger Fabric
-------- | -------- | :-: | :-: | :-:
[Checks-Effects-Interactions Pattern](Idioms/Checks-Effects-Interactions%20Pattern/README.md) |Prevent a reentrancy attack within the same function of the smart contract | |&#x2611; |
[Deactivation Pattern](Idioms/Deactivation%20Pattern/README.md) | Disable a smart contract instead of destructing it so that all function calls result in a revert and no assets sent to the contract are lost | |&#x2611; |
[Error-Handling Pattern](Idioms/Error-Handling%20Pattern/README.md) | Handle errors in smart contracts appropriately | |&#x2611; |
[External-Call Pattern](Idioms/External-Call%20Pattern/README.md) | Handle failed external calls and prevent unintended side effects | |&#x2611;  |
[Guarding Pattern](Idioms/Guarding%20Pattern/README.md) |Restrict authorization to execute smart contract functions to particular accounts in defined contexts |&#x2611;  |&#x2611;  | &#x2611;
[Overflow/Underflow Pattern](Idioms/Overflow%20Pattern/README.md)|Prevent variable overflow and underflow caused by unappropriate data type use | |&#x2611; |
[Token Pattern](Idioms/Token%20Pattern/README.md) |Mitigate the risks related to the update of smart contracts keeping tokens | |&#x2611; |

# Structure of Software Design Patterns

To make smart contract developers aware of the peculiarities of smart contracts and how to deal with these peculiarities, we present several software design patterns. The software design patterns comprise three levels of abstractions:

- _Architectural patterns_ describe “[…] a fundamental structural organization or scheme for software systems and provide a set of predefined subsystems, specify their responsibilities, and include rules and guidelines for organizing the relationships between them” [1, p. 12].

- _Design patterns_ provide “[…] a scheme for refining the subsystems or components of a software system, or the relationships between them” [1, p. 13] to solve a general design problem within a certain context.

- _Idioms_ are patterns on the lowest level of abstraction and “describe[s] how to implement particular aspects of components or the relationships between them using the features of the given language” [1, p. 14].

Each pattern is comprised of components to describe the pattern in a consistent and comprehensive manner. In this repository, we follow the _canonical form_ comprisong the following elements: 

- _Name:_ the pattern in one word "[…] to use a single word or short phrase to refer to the pattern, and the knowledge and structure it describes" [2, p. 5]. 

- _Context:_ "the preconditions under which the problem and its solution seem to recur, and for which the solution is desirable. This tells us the pattern's applicability" [2, p. 5].

- _Problem:_ "[…] the goals and objectives [the developer] wants to reach within the given context and forces. Often the forces oppose these objectives as well as each other" [2, p. 5].

- _Forces:_ "[…] the relevant forces and constraints and how they interact/conflict with one another and with goals we wish to achieve […]. Forces reveal the intricacies of a problem and define the kinds of trade-offs that must be considered in the presence of the tension or dissonance they create" [2, p. 5].

- _Solution:_ the "static relationships and dynamic rules describing how to realize the desired outcome. This is often equivalent to giving instructions which describe how to construct the necessary work products" [2, p. 5].

- _Examples:_ "one or more sample applications of the pattern which illustrate: a specific initial context; how the pattern is applied to, and transforms, that context; and the resulting context left in its wake" [2, p. 6].

- _Resulting Context:_ "the state or configuration of the system after the pattern has been applied, including the consequences (both good and bad) of applying the pattern, and other problems and patterns that may arise from the new context. It describes the postconditions and side-effects of the pattern" [2, p. 6].

- _Rationale:_ "a justifying explanation of steps or rules in the pattern, and also of the pattern as a whole in terms of how and why it resolves its forces in a particular way to be in alignment with desired goals, principles, and philosophies" [2, p. 6].

- _Related Patterns:_ "the static and dynamic relationships between this pattern and others within the same pattern language or system" [2, p. 6].

- _Known Uses:_ "[…] known occurrences of the pattern and its application within existing systems" [2, p. 6].

# References
[1] F. Buschmann, Ed., Pattern-oriented software architecture: a system of patterns. Chichester; New York: Wiley, 1996.  
[2] B. Appleton, “Patterns and Software: Essential Concepts and Terminology.” 2000, Accessed: Aug. 02, 2019. [Online]. Available: http://www.enteract.com/~bradapp/docs/patterns-intro.html.
