---
layout: workshop
title: Azure for developers
description: ""
tags: [Architecture, Azure, API Gateway, API Management, Service Bus, Messaging, Table Storage, Queue Storage, Blob Storage, App Services, Azure Functions, Durable Functions, Terraform, Tracing, Application Insights, Cloud Orchestration, Service Discovery, Azure DevOps, Security, Azure Search, Polyglot Persistence, DDD, Monitoring, Data modeling, Eventual consistency]
image:
  feature: workshops/azure-for-developers/logo.jpg
TheoryToPracticeRatio: 90 
---

This workshop is designed to introduce developers to a wide array of most commonly used Azure services. Key features:

- Very hands-on heavy
- Practical usage scenarios
- Helps developers choose the proper service to a given problem
- Cost optimization

# <img src="/data/workshops/list.svg" class="listIcon" > Program

0. **Introduction**
1. **Cloud orchestration with Terraform**
    1. Why use an orchestration tool?
    2. Connecting to Azure using a Service Principal
    3. File structure
    4. Dependency graphs
2. **Compute**
    1. App Service
        1. How it works and usages
        2. Troubleshooting
            1. Kudu
            2. Logs
            3. Remote debugging
        3. Deployment
            1. Git, FTP, Zip  deploy
            2. Deployment slots
        4. Plans, scaling, and pricing
    2. [Azure Functions](https://azure.microsoft.com/en-us/services/functions/)
        This training is executed in **NodeJS** and **C#**.
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