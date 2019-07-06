---
layout: workshop
title: Testing for developers
description: ""
tags: [Testing, Moq, NUnit, Refactoring, SOLID, Design Patterns, Angular, dotnet, Angular, JavaScript ]
image:
  feature: workshops/testing-for-developers/logo.jpg
TheoryToPracticeRatio: 95  
---

This training is design to make writing tests easier by:

- showing how good practices in writing code translate to easy to write tests
- learning how to **refactor** bad code to easily testable code.
- making sure attendees know the testing tools that they use daily
- organizing when to use which approach in testing different scenarios
- passing good practices that minimize test maintenance overhead
- learning when to remove tests

# <img src="/data/workshops/list.svg" class="listIcon" > Program

0. **Introduction**
1. **Testing**
    1. How to name tests
    2. How to write assertions
    3. Test organization 
    4. DRY in tests
    5. Patterns and anti-patterns in tests.
        1. Inheritance vs. Composition
        2. Integration tests 
    6. Data Driven testing
        1. How to set up and organize
        2. How to collect sample data from production and test environments
        3. Combinatorial testing
        4. Managing the number of test cases
        5. Evaluating the benefits and drawbacks  
    6. Time saving features of testing frameworks ([NUnit](https://nunit.org/)/[Fluent Assertions](https://fluentassertions.com/))
2. **Mocking**
    1. Understanding how mocking works.
    2. When to mock and when not to.
    3. Mock verification.
    2. Time saver features of mocking frameworks ([Moq](https://github.com/moq)/[NSubstitute](https://nsubstitute.github.io/)) 
3. **Good code leads to easy tests**
    On a very simple program, attendees experience how good code allows moving from a complex 50 test to a 5 line one. 
4. **SOLID as guidance on how to write testable code** 
    We start from a sample "not too bad" application, and by applying SOLID principles and refactoring the code, we can write more straightforward tests that have a higher coverage.
5. **Design patterns as recipes to testable code**
    1. **Factory** and **Abstract Factory** design pattern - how to write less but more meaningful tests
    2. **Builder design pattern** - its usage in testing
    3. **Strategy design pattern** - separating object responsibilities leads to easy to test classes
    4. **State Machine design pattern** - rethinking design habits with OOP principles leads to readable and trivial to test code
    5. **Rules design pattern** - moving from nested ifs to a clean and testable code
    6. **Singleton design pattern** - the proper usage of one of the most common design patterns
6. **[Optional] Testing Angular**
    1. Unit tests
    2. Service testing
    4. Integration tests
    4. Component tests
    5. Component integration tests
    6. UI test
    7. Router tests