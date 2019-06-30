---
layout: workshop
title: Microservices in Azure
description: ""
tags: [Architecture, dotnet, Microservices, Patterns, Messaging, Polly, Retry, Sagas, Publish/subscribe, PubSub, Kubernetes, k8s, Docker, Ocelot, API Gateway, JWT, Tracing, Observability, Eventual consistency, Service Bus, Monitoring, Distributed transactions, Publish/Subscribe, PubSub, Messages, Polly, Orchestration, Choreography, Security, Authentication, Circuit Breaker, Fallback, Caching, Timeout, Service discovery, API Management, Azure Functions, Durable functions, AKS, Application Insights, Service Bus, Terraform, Key Vault, Azure DevOps, Azure Kubernetes Services, Polyglot persistence, NodeJS, ]
image:
  feature: workshops/microservices-in-azure/logo.jpg
TheoryToPracticeRatio: 90  
---

# Goal

From theory to practice. This workshop is designed to put developers and architects on a fast track to developing distributed systems in Azure by:

- Starting with the most needed theory shown on attendee done exercises.
- Highlighting the differences between Azure compute offering.
- Being hands-on heavy 
- Using tools for the whole application lifecycle. From local development, through deployment, to operations.

# Program

0. **Introduction**
1. **Synchronus patterns**
    This part of the training is done using [Kubernetes](https://kubernetes.io/).
    1. Retry (normal, exponential retry, jitter)
    2. Timeout (external and internal)
    3. Fallback
    4. Caching
    5. Service discovery using 
    6. Health checks vs. liveness checks
    7. API gateway ([API Management](https://azure.microsoft.com/en-us/services/api-management/))
        1. Role of API Gateway
        2. Request aggregation
2. **Security**
    1. Authentication
    2. Internal security
    3. Security features of [API Management](https://azure.microsoft.com/en-us/services/api-management/)
    4. JWT tokens
        1. Symmetric keys
        2. Asymmetric keys
        3. Token validation
        4. Hardening security
        5. Key/secret management in [Key Vault](https://azure.microsoft.com/en-us/services/key-vault/)
        6. Risks and issues
        7. Token encryption
3. **Asynsynchronus patterns**
    This part of the training is done using [Azure Service Bus](https://azure.microsoft.com/en-US/services/service-bus/).
    1. Request/response with messages
    2. Publish/subscribe
    3. Command vs. event vs. message
    4. Role of time and message scheduling
    5. Orchestration based sagas
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
        13. Message denial (nontechnical failure)
        14. Evaluating system consistency
4. **Hosting**
    1. [App Service](https://azure.microsoft.com/en-us/services/app-service/)
        1. How it works and placement on the axis of Azure services.
        2. Plans and pricing
        3. Scaling
            1. Auto-scaling
        4. Deployment
            1. Deployment slots
        5. Debugging
        6. Linux vs. Windows
        7. Running Docker containers
    2. [Azure Functions](https://azure.microsoft.com/en-us/services/functions/)
        This training is executed in **NodeJS** and **C#**.
        1. Architecture and placement on the axis of Azure services.
        2. Plans and pricing
        3. Local development
        4. Cross function communication
            1. Durable functions
    3. [AKS](https://azure.microsoft.com/en-us/services/kubernetes-service/)
        1. K8s vs AKS
        2. Scaling
        3. Deployment
4. **Operations**
    1. Application Insights 
        1. Tracing
        2. Logging
        3. Profiling
    3. Azure DevOps
        1. Deployment
        2. Build and deployment pipelines
            1. Container deployment to Azure Registry