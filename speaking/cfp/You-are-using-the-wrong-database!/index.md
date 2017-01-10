---
layout: page
title: You are using the wrong database!
description: "Description of my talk - You are using the wrong database!"
tags: [architecture, database, performance, modeling, relational database, key-value database,in memory,search, stream, embedded, solr, elastic, Redis, SQL ]
image:
  feature: speaking/cfp/You-are-using-the-wrong-database!/logo.jpg
---

## Short abstract

Relational, graph, document, in memory, key-value, search, stream, embedded - those are the most common database types. This talk will cover types of databases, their weaknesses, main players, strong points when to use them, and when it might not be the best idea and lastly how to combine them.

## Description

How many JavaScript frameworks vs. how many databases do You know? It is most crucial and complicated part of the system. It also has the biggest effect in terms of modeling and performance. Most often we pick based on our preferences, or what seems hip at the moment. And there is a lot to choose from: relational, graph, document, key-value, search, stream, embedded to name the most common types. And the best part is, we don’t have to choose one! This talk will cover types of databases, their weaknesses, main players, strong points when to use them, and when it might not be the best idea and lastly how to combine them.

## Other

I’ve been heavily interested in different databases since I’ve started my pet project - cookit.pl. The front of the service is a food recipe search engine. The back is crawling almost 1 thousand websites. It determines if the page contains a recipe, extracts the text, ingredients, units, and amount. Images are similarly processed for relevance, rescaled and saved. This all sums up to 1 TB of data being processed on an Intel i3 with 8 gigabytes of RAM.

With those constraints and the fact that this data that is used for search, individual recipe display and NLP I’ve quickly understood that the database is the most common performance bottleneck and has a huge influence on how the domain is modeled. Since then I’ve been using relational, graph, object, stream and key-value databases.

This talk was inspired by a common tendency to use a “one fits all” database despite the fact that it will be average in every area of its usage. My goal is to show how diverse the world of databases is, how huge performance gains can easily be achieved by using the right database for the right problem.