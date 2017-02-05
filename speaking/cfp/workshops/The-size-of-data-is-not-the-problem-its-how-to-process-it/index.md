---
layout: page
title: The size of data is not the problem. Its how to process it
description: "Description of my workshop -  The size of data is not the problem its how to process it"
tags: [performance, .net, Microsoft TPL DataFlow, TPL, optimizations, data processing, parallelism, workshop]
image:
  feature: speaking/cfp/workshops/The-size-of-data-is-not-the-problem-its-how-to-process-it/logo.jpg
  credit: http://www.wikiwand.com/
  creditlink: http://www.wikiwand.com/en/Cooling_tower
---

## Short abstract

Ever wondered how to process hundreds of gigabytes of data in .NET? Even more, do it with CPU and memory restrictions? How to apply different levels of parallelism for each step and actually increase code readability and ease of debugging? Lastly how to monitor such a workflow?    

## Description

Everyone is talking about BIG data, but no one can actually tell where big data starts. The last year thought me that hundreds of gigabytes is not a big data problem. The actual problem was how to efficiently use the resources of the machine I've had.

This talk will be a compression of more than one year of knowledge gained while running a web crawler processing up to 1 TB of data.

This workshop will help You:

- understand parallelization using Task vs Threads
- the pitfalls of using Tasks, and the gains they provide
- understand resource boundness
- design a data processing workflow
- understand profiling multi-threaded application
- implement monitoring for such a workflow
- understand Microsoft TPL Dataflow

We will start with a problem, and iterate over many possibilities how to solve it. Looking at what those ideas solve and what they make harder.

We will go through the fundamentals and the building blocks of Microsoft TPL Dataflow looking at how the design might help with some issues. With this knowledge, we will implement a data flow and analyze its strengths and weaknesses.
Next part will be applying limits to resources our workflow can use and diversifying the level of parallelism between the blocks.
Then a short look at how to test such a solution.
The last part will concentrate on monitoring of a deployed workflow and how to manage it on production.
