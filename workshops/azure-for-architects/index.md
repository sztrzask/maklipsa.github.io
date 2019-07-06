---
layout: workshop
title: Azure for Architects
description: ""
tags: [Architecture, Azure, Performance, CQRS, Events, Messaging, API Gateway, API Management, Azure Search, Terraform, Azure Functions, App Services, Application Insights, Key Vault, Security, Durable functions, NodeJS, dotnet, DDD, Observability, Messaging, Table Storage, Queue Storage, Blob Storage, Performance, Monitoring, Application Insights, Observability, Polyglot persistence, Eventual consistency]
image:
  feature: workshops/azure-for-architects/logo.jpg
TheoryToPracticeRatio: 80
---

This workshop is designed to give architects a high-level practical overview of Azure offering by:

- being hands-on heavy
- focusing on use cases for each service
- incorporating good cloud architecture patterns and practices 

# <img src="/data/workshops/list.svg" class="listIcon" > Program

0. **Introduction**
1. **Cloud orchestration with Terraform**
    1. Why use an orchestration tool?
    2. Connecting to Azure using a Service Principal
    3. File structure
    4. Dependency graphs
2. **Cloud Architecture**
    1. Good practices
    2. Anit patterns
    3. Polyglot persistence
3. **Compute**
    1. Azure Cloud Services
        1. Use cases
        2. Scaling
    2. App Service
        1. Internal architecture
        2. Plans and pricing
        3. Scaling
            1. Auto-scaling
        4. Deployment
            1. Deployment slots
    2. Azure Functions
        1. How it works and placement on the axis of Azure services.
        2. Plans and pricing
        3. Local development
        4. Cross function communication
            1. Durable functions
        5. Troubleshooting and monitoring
    3. AKS
        1. Introduction to Kubernetes
        2. Deployments
        3. K8s vs. AKS
        4. Scaling
        5. Pricing
3. **Data**
    1. Blob Storage
        1. Block Blobs
        2. Append Blobs
        3. Page Blobs
        4. Security
        5. Good practices 
    2. Azure Table Storage
        1. Introduction to wide table databases
            1. Consistency
        2. Architecture and usage
        3. Performance
    3. Cosmos DB
        1. Multiple offerings in Cosmos DB
        2. Modeling data for different databases
            1. Document databases
            2. Graph databases
            3. Wide table
            4. Key-value
        2. Partition key
            1. Importance of selecting a proper partition key
            2. How to pick the right partition key
        3. Pricing, provisioning, and RUs
    4. Azure Search
4. **Messaging**
    1. Azure Service Bus
        1. Messaging patterns
        2. Queues
        3. Topics
        4. Large messages
        5. Security
        6. Pricing and limitations
    2. Azure Queue Storage
        1. Usage, limitations, and pricing
    3. Azure Event Grid
        1. Architecture
        2. Limitations and use cases
        3. Pricing
    4. Azure Event Hub
        1. Architecture
        2. Limitations and use cases
        3. Pricing
5. **Operations**
    1. Application Insights
        1. Integration with applications
        2. Tracing
        3. Log Analytics
        4. Alerts
            1. Smart Detection
        5. Custom metrics
    2. **Azure DevOps**
        1. Repos
        2. Build pipelines
        3. Deployment
        4. Quality gates 
6. Security
    1. Key vault
    2. API Management