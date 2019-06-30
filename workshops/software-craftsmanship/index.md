---
layout: workshop
title: Software Craftsmanship
description: ""
tags: [SOLID, DRY, KISS,Refactor, dotnet, reference type, value type, Craftsmanship, Developer, Design Patterns,Factory design pattern, Builder design pattern, Abstract factory design pattern, Strategy design pattern, Object pool design pattern, State machine design pattern, Rules design pattern, Chain of responsibility design pattern, Singleton design pattern, Observable design pattern ]
image:
  feature: workshops/software-craftsmanship/logo.jpg
TheoryToPracticeRatio: 100
---

# Goal

Everyone needs a refresh or a reminder of good coding practices. This training offers a unique take by:

- Being 100% hands-on.
- Showing how to refactor from bad to good code.
- Presenting design patterns in a modern take. They are more than 20 years old by now.
- Including proper behaviors with DI containers and ORM frameworks. 

# Program

1. **SOLID is the basis for understanding design patterns** 
    SOLID principles are the key to understanding design patterns.
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
3. Knowing Your toolset:
    1. **DI containers**
        1. Understanding how a DI container works.
        2. Defining container responsibilities.
        3. How to organize registrations.
        4. Proper lifecycle management.
    2. **Data modeling and ORM** 
        1. Understanding how an ORM framework works.
        2. Modeling hierarchies.
        3. Modeling value and refernce types.
        4. Auditing objects with listners.