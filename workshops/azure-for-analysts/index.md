---
layout: workshop
title: Azure for Analysts
description: ""
tags: [Azure, Data Lake, NoSQL, Redis, Table Storage, Key-value, Databases, Wide-table database, Document database, Grap database, Full text search, Azure Search, Cosmos DB, Data modeling, Terraform, Cloud orchestration, Machine Learning, Cognitive Services, Azure Storage, Polyglot persistence, Gremlin, Azure ML Studio, Blob Storage, Eventual consistency ]
image:
  feature: workshops/azure-for-analysts/logo.jpg
TheoryToPracticeRatio: 80  
---

This workshop is designed to give data analysts a high-level practical overview of Azure data offerings by:

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
2. **Cloud data patterns**
    1. Consistency
    2. Data transformation
3. **Azure Storage**
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
4. **Cosmos DB**
    1. Multiple offerings in Cosmos DB
    2. Modeling **and querying** data for different databases
        1. Document databases
        2. Graph databases
        3. Wide table
        4. Key-value
    2. Partition key
        1. Importance of selecting a proper partition key
        2. How to pick the right partition key
    3. Pricing, provisioning, and RUs
5. **Azure Search**
    1. Understanding TFIDF
    2. Modeling data for search
    3. Tokenization
    4. Steeming
    5. How similarity is calculated
    6. Boosting
    7. Visualization
6. **Azure Functions as triggers and data transformations**
    1. Local development
    2. Integrating with other Azure services
    3. Deployment
7. **Azure ML Studio**
    1. Usage patterns
    2. Use of ready models
    3. Developing custom models
8. **Cognitive Services**
    1. Overview of the offering
    2. Use of API
9. **Azure Data Lake**
    1. Introduction
    2. Processing pipelines