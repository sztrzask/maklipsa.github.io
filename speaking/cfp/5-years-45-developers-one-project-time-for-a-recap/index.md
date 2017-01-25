---
layout: page
title: 45 developers, 5 years, one ERP system. Time for a recap
description: "Description of my talk - 45 developers, 5 years, one ERP system. Time for a recap"
tags: [architecture, .net, team leading, team building, summary]
image:
  feature: speaking/cfp/5-years-45-developers-one-project-time-for-a-recap/logo.jpg
---

## Short abstract

There is a lot you can do with 45 developers over five years. We build a distributed, modular ERP system. We also made a lot of mistakes, had great ideas, and drunk some beer in the mean time. This will be a list of things that we regret and are proud of. From business relations, through team leading and architecture down to code.    

## Description

This is a story of building a big distributed, web-based, modular ERP system from scratch. First, we will look at the high-level architecture of the system, database servers, and teams. Then we go a bit deeper and discuss how we manage synchronous and asynchronous communication, modularity and data replication. Then I will explain why we created a custom DSL for view creation and how this allows us to change non-functional requirements without affecting the business code. Going deeper takes us into how we modeled such concepts as multi-language text and multi-currency amounts. Next part will be a recap:

- Why did we not use Angular? 
- What are the pain points? 
- What are we changing? 
- What was the key to not failing? 
- How some things can't be done right from the start, and just need time? 
- And the most important: If done again what would we change and what would we leave as it is?