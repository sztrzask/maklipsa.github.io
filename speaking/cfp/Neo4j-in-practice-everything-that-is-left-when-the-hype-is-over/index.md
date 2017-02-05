---
layout: page
title: Neo4j in practice - everything that is left when the hype is over
description: "Description of my talk - Neo4j in practice - everything that is left when the hype is over"
tags: [architecture, database, graph database, Neo4j]
image:
  feature: speaking/cfp/Neo4j-in-practice-everything-that-is-left-when-the-hype-is-over/logo.jpg
  credit: The Matrix - Warner Bros. Pictures
---

## Short abstract

From graph modeling, through design constraints, to good practices when designing graph databases. Next a look at Cypher, indexes, query plans, hints and everything that is needed to write fast queries. Ending with some hints on how to fit Neo4j into a multi persistent environment. This walk is everything I wish someone told me before I’ve started using Neo4j.

## Description

Starting with basics of graph modeling, through the strangest design constraints, to good practices when modeling problems using graph databases. Next a look at how to query graph models, so a big portion of Cypher and indexes, query plans, hints and everything that is needed to write fast queries. We will end with some hints how to fit Neo4j into a multi persistent environment.

## Other

This is a continuation of my [Introduction to graph databases talk](/speaking/cfp/Introduction-to-graph-databases).

My adventure with graph databases started a few years ago when I tried to model a medium size graph structure on a relational database.The fact that I was not using the right tool for this job became clear quite fast. I’ve checked many graph databases at that time, but Neo4j with Cypher was a clear winner.

This walk is everything I wish someone told me before I’ve started using Neo4j. Some things are bad, some are great but a lot of them are just different. I’ll try to talk about things that actually needed to use Neo4j in a custom scenario.