---
layout: workshop
title: Application architecture
description: ""
tags: [Architecture, Performance, Hexagonal architecture, Onion architecture, Hangfire, Dataflow, ROP, Railway orientated Programming, Event architecture, 4C, Observability, Tracing, Distributed, Scaling, ORM, IoC, NHibernate, MiniProfiler, Polyglot persistence ]
image:
  feature: workshops/application-architecture/logo.jpg
TheoryToPracticeRatio: 95 
---

This training is design to widen the scope of what software architects can do and give them tools to execute by:

- showing how to use DI container and ORM conventions for application extensive problem-solving. 
- giving tools to mitigate serious performance problems in the development phase.
- showing different styles of application architecture and when to use them

# <img src="/data/workshops/list.svg" class="listIcon" > Program

0. **Introduction**
    1. What are the responsibilities of application architecture
    2. Critical areas of influence in application architecture
1. **Application object lifecycle - DI containers**
    1. Understanding how a DI container works.
    2. Defining the responsibilities of a container.
    3. How to organize registrations.
    4. Proper lifecycle management.
    5. Design and performance pitfalls.
    4. Useful features
2. **Data modeling and ORM** 
    1. Understanding how an ORM framework works.
    2. Modeling hierarchies.
    3. Modeling value and reference types.
    4. Auditing objects with listeners.
    5. Architectural level mitigations of the N+1 problem.
    6. Full vs. lightweight ORMs.
3. **Application level architecture**
    1. Layered
    2. Hexagonal/Onion Architecture
    3. Railway orientated Programming
    4. Dataflow
    5. Event architecture
    6. Reactive
    7. Background processing
    8. CQRS
4. **Avoiding performance problems with MiniProfiler**
    1. Installation and configuration
    2. Scopes and use in background jobs.
    3. Good and bad practices.
    4. Time machine.
    5. Security and performance cost.
    6. Recording performance issues from testing environments and automating issue reporting.