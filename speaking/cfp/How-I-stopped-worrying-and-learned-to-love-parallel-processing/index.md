---
layout: page
title: How I stopped worrying and learned to love parallel processing
description: "Description of my talk - How I stopped worrying and learned to love parallel processing"
tags: [performance, .net, Microsoft TPL DataFlow, TPL, optimizations, data processing, parallelism]
image:
  feature: speaking/cfp/How-I-stopped-worrying-and-learned-to-love-parallel-processing/logo.jpg
---

## Short abstract

How to process 1 TB of data do it fast using just enough resources? How to organize and parallelize big data processing workflows in .NET? How to control CPU and memory usage easily?

## Description

Processing hundreds of gigabytes of data shows that old, known tricks don’t work. Moreover, they can significantly slow down processing. The problem gets even more complicated when its individual steps are bound differently, have a different level of parallelization, and there are significant memory and CPU constraints. This talk will demonstrate problems I’ve had designing a system processing ~1TB of data and how using TPL Dataflow takes most of that pain away.

## Other

The inspiration for this talk was the problem I’ve faced when developing my side project - [cookit.pl](http://cookit.pl). The front of the service is a food recipe search engine. The back is crawling almost 1 thousand websites. For each web page, it determines if the page contains a recipe, extracts the text, ingredients, units, and amount. Images are similarly processed for relevance, rescaled and saved. This all sums up to 1 TB of data being processed on an Intel i3 with 8 gigabytes of RAM.

The problem gets harder since every step of this process is differently bound (by the CPU, memory, network or non-parallelizable connection), my resources are significantly limited and the server is running also the website.

This talk will show:

- the pitfalls of micro-optimizations in big data processing workflows
- how to handle parallelization in big data processing workflows
- how to structure block of the process
- how Microsoft TPL Dataflow helps in such situations
This will be based on two years of experience and troubleshooting this implementation in a production environment.