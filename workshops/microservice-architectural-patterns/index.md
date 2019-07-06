---
layout: workshop
title: Microservice Architectural Patterns
description: ""
tags: [Architecture, dotnet, Microservices, Patterns, Messaging, Polly, Retry, Sagas, Publish/subscribe, PubSub, Kubernetes, k8s, Docker, Ocelot, API Gateway, Mass Transit, RabbitMQ, Consul, JWT, Tracing, Observability, Eventual consistency, Service Bus, Monitoring, Distributed transactions, Publish/Subscribe, PubSub, Messages, Polly, Orchestration, Choreography, Security, Authentication, Circuit Breaker, Fallback, Caching, Timeout, Service discovery]
image:
  feature: workshops/microservice-architectural-patterns/logo.jpg
TheoryToPracticeRatio: 95  
---

Splitting a system into multiple applications poses multiple new challenges. This training aims to:

- Acquaint attendees with distributed systems design patterns
- Show good practices and how to integrate them into the application on an architectural level
- Highlight what, when, and how will go wrong. Also how to detect that it did.
- Build awareness of how to use infrastructure solutions for mitigating problems.

# <img src="/data/workshops/list.svg" class="listIcon" > Program

0. **Introduction**
1. **Synchronus patterns**
    This part of the training is done using [Docker Compose](https://docs.docker.com/compose/) and [Kubernetes](https://kubernetes.io/).
    1. Retry (normal, exponential retry, jitter)
    2. Timeout (external and internal)
    3. Fallback
    4. Caching
    5. Circuit breaker
	1. Multi-server circuit breaker
    6. Service discovery using 
    7. Health checks vs. liveness checks
    8. API gateway
        1. Role of API Gateway
        2. Request aggregation
2. **Security**
    1. Authentication
    2. Internal security
    3. Role of an API gateway
    4. JWT tokens
        1. Symmetric keys
        2. Asymmetric keys
        3. Token validation
        4. Hardening security
        5. Key/secret management
        6. Risks and issues
        7. Token encryption
3. **Asynsynchronus patterns**
    This part of the training is done using [Rabbit MQ](https://www.rabbitmq.com/) and [Azure Service Bus](https://azure.microsoft.com/en-US/services/service-bus/).
    1. Request/response with messages
    2. Publish/subscribe
    3. Command vs. event vs. message
    4. Role of time and message scheduling
    5. Sagas
        1. Orchestration
        2. Choreography
        3. Routing Slip
    6. Problems with message architecture and ways to mitigate it
        1. Message deduplication
        2. Dead letter queue
        3. More than one delivery
        4. Message order
        5. Lack of transactionality
        6. Zombie messages
        7. Message versioning
        8. Data change between message send and message delivery
        9. Performance
        10. Large messages
        11. Parallel message processing
        12. No guarantee of delivery 
        13. Message denial(non-technical failure)
        14. Evaluating system consistency
4. **Operations**
    1. Tracing
        1. Over Http calls
        2. Over Messages
    2. Logging
    3. Deployment