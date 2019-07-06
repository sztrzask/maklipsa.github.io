---
layout: workshop
title: Software Design Patterns
description: ""
tags: [SOLID, DRY, KISS, Refactor, dotnet, Refference type, Value type, Craftsmanship, Developer, Design Patterns, Factory design pattern, Builder design pattern, Abstract factory design pattern, Strategy design pattern, Object pool design pattern, State machine design pattern, Rules design pattern, Chain of responsibility design pattern, Singleton design pattern, Observable design pattern, Command design pattern, Mediator design pattern, Decorator design pattern, Visitor design pattern, Context]
image:
  feature: workshops/software-design-patterns/logo.jpg
TheoryToPracticeRatio: 95  
---

Most developers know design patterns, but don't use them. This training is design to change this by:

- Being 100% hands down.
- Attendees get to know the patterns by refactoring sample code using SOLID principles. This way they **understand it instead of just knowing it**.
- Each pattern is discussed based on the work done by one of the attendees.
- Exercises are designed so that attendees see the pitfalls of each pattern. 
- Presenting design patterns in a modern take. They are more than 20 years old by now.
- Attendees learn how to refactor existing code, not only to apply it in greenfield projects.

# <img src="/data/workshops/list.svg" class="listIcon" > Program

1. **SOLID is the basis for understanding design patterns** 
    Without understanding SOLID principles, design patterns are just a definition.
2. **Design patterns as recipes to testable code**
    1. **Factory** and **Abstract Factory** design patterns - basic, but still misunderstood and misused pattern.
    2. **Builder design pattern** - how it is different from a state machine and how beneficial it is in tests.
    3. **Strategy design pattern** - separating object responsibilities leads to smaller and cleaner classes.
    4. **Object pool** - understanding the most basic patterns for IO communication.
    5. **State Machine design pattern** - rethinking code habits with OOP principles leads to readable and trivial to test code
    6. **Rules design pattern** - moving from nested `ifs` to clean, readable and testable code.
    7. **Chain of responsibility design pattern** - key pattern to understand most UI frameworks.
    8. **Singleton design pattern** - refreshed, and proper usage of one of the most common design patterns. We also measure different implementations with [Benchmark.net](https://benchmarkdotnet.org/) to remove any performance myths.
    9. **Observable design pattern** - a very powerful pattern, especially when used with [reactive programming](/workshops/application-architecture) and [Reactive Extensions](https://github.com/dotnet/reactive).
    10. **Command** and **mediator** design patterns - the key to understand event architecture
    11. **Decorator design pattern** - add responsibilities to objects dynamically
    12. **Visitor design pattern** -  without change define a new operation to a class
    13. **Context** - not an official design pattern, but a construct used in C# and .net.