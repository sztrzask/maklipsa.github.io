---
layout: page
title: Talks
description: "List of event I had pleasure speaking at"
---

I believe that sharing knowledge is a key activity keeping the community live and active, that is why I present what I have learned on conferences and user groups.

# 23.07.2016 - Graphs, Neo4j in practice - given at Warsaw .NET User Group[[meetup](http://www.meetup.com/WG-NET/events/231937626/)] [[slides](indexoutofrange.com/presentations/PracticalNeo4j/index.html)]
   Deep dive into Neo4j. This talk an effect of preparing to use Neo4j in my pet project - [cookit.pl](http://cookit.pl). It covers a wide range of topics starting from the principles of modeling a graph domain, with some tricks and solutions to common problems. Then I cover syntax and most useful functions of Neo4j query language Cypher. An addition to this is the next part - profiling and optimization covering how Cypher works, how to profile it and what practicess to avoid. I also talk about different modes in witch Neo4j can be run (stand alone and embedded) and benefits and limitations resulting from it. Continuing the performance theme I talk about different types of indexes used in Neo4j, their limitations, APIs,usages and practices. 
   The last section covers administrative and maintenance capabilities from Neo4j itself and from JVM.      

# 11.04.2016 - Graph databases - why and how - given at 4Developers conference[[youtube](https://www.youtube.com/watch?v=ISKC25G1HCY)][[conference page]()]
   This was evolution of the [Why dragons need graphs](#whyDragonsNeedGraphs) presentation given on Warsaw .NET user group. Shortened because of the time limit, refined, with new examples and more practical angle.

# 20.08.2015 - <a name="whyDragonsNeedGraphs"></a> Why dragons need graphs - given at Warsaw .NET User Group [[meetup](http://www.meetup.com/WG-NET/events/224309541/)][[youtube](https://www.youtube.com/watch?v=Bo6uOQ-P25w)]
   An introduction to graph databases. The talks starts with a short intro to graph theory its history and meaning for current computing. Then I try to show why relational databases are not about relations, but about data and why, despite being able to, You should not use it to model a highly relational domain.
   Then I give a high level overview of what is the current state of graph databases, and why there is such huge diversity among them. This is backed up by different ways graph databases are being classified.
   The next part shows real life examples where graph databases are being used, and problems they are solving. This covers usages by well known companies and taking part in core business workflows.
   The next part is presenting those concepts on the most popular graph database on the market - Neo4. This part contains an into to Cypher (Neo4j querry language) and has live examples of solving the same problem on a relational database and a graph database.


# 5.06.2015 - TPL DataFlow - given at Warsaw .NET User Group [[group page](http://www.wg.net.pl/aktualnosci/zaproszeniena86spotkaniewgnet)] [[youtube](https://www.youtube.com/watch?v=PL4pkv6YAxg)]
   A walkthrough of what Microsoft TPL Dataflow has to offer and how can it be used to implement workflows with various degree of parallelism transforming large amounts of data.  


# 10.10.2014 - Lessons learned building a large distributed system - given at Warsaw .NET User Group [[group page](http://www.wg.net.pl/aktualnosci/zaproszeniena75spotkaniewgnet)] [[slides](https://www.slideshare.net/secret/Apdl1XQrrJ0acw)]
   With two of my friends and coworkers we shared some knowledge from designing and building a large distributed system. The project is a from scratch ERP system for a multinational company build with scalability and modularity in mind. We shared knowledge starting from high level network architecture of out application, database servers and load balancers. Then we talked how we manage synchronous and asynchronous communication, modularity and data replication. The next part goes into how we used ASP.MVC and designed a domain language on top of it that allows us to auto create views, control serialization and implement non functional requirements without the need to change existing business code. Going deeper takes us into how we modeled such concepts as multi language text and  enumeration values using [NHibernate](http://nhibernate.info/), [Fluent NHibernate](http://www.fluentnhibernate.org/) and custom code. We end with some tips how to manage development of such a huge system and allow 45+ developers to work effective.

