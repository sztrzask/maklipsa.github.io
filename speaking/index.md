---
layout: page
title: Speaking
description: "List of events I had pleasure of speaking at"
---

I believe that sharing knowledge is a key activity keeping the community live and active. That is why I present what I have learned on conferences and user groups.

## Talks:
- 04-05.02.2017 - **Graph databases - why and how** - [EN]FOSDEM [conference page](https://fosdem.org/2017/schedule/event/graph_intro_graph_databases/)
- 26.01.2017 - **Graph databases - why and how** - rg-dev
- 24.01.2017 - **Graph databases - why and how** - [EN]BOB 2017 Konferenz [conference page](http://bobkonf.de/2017/warda.html)
- 30.11.2016 - **Graph databases - why and how** - Dev@LDZ - [meetup](https://www.meetup.com/dev-LDZ/events/235332452/)
- 14.11.2016 - **Graph databases - why and how** - PyWaw - [meetup](https://www.meetup.com/PyWaw-Python-Warsaw-User-Group/events/234937571/)
- 08.11.2016 - **Graph databases - why and how** - Dev@ZG - [meetup](https://www.meetup.com/DEV-ZG/events/234737689/)
- 05.11.2016 - **How I stopped worrying and learned to love parallel processing** - [conference page](http://dotnetconf.pl/Agenda)[[youtube](https://www.youtube.com/watch?v=Dup24FdDYj4&t=572s)]
- 26.10.2016 - **Graph databases - why and how** - PG.NET [[youtube](https://www.youtube.com/watch?v=BW3gD-eb9zM)][[group page](http://events.pozoga.eu/poznanska-grupa-net-62/)]
- 23.07.2016 - **Neo4j in practice - everything that is left when the hype is over** - Warsaw .NET User Group[[meetup](http://www.meetup.com/WG-NET/events/231937626/)] [[slides](indexoutofrange.com/presentations/PracticalNeo4j/index.html)][[youtube](https://www.youtube.com/watch?v=3n1fVvW-oW8)]
- 11.04.2016 - **Graph databases - why and how** - 4Developers conference[[youtube](https://www.youtube.com/watch?v=ISKC25G1HCY)]
- 20.08.2015 - <a name="whyDragonsNeedGraphs"></a> **Why dragons need graphs** - Warsaw .NET User Group [[meetup](http://www.meetup.com/WG-NET/events/224309541/)][[youtube](https://www.youtube.com/watch?v=Bo6uOQ-P25w)]
- 05.06.2015 - **How I stopped worrying and learned to love parallel processing** [[group page](http://www.wg.net.pl/aktualnosci/zaproszeniena86spotkaniewgnet)] [[youtube](https://www.youtube.com/watch?v=PL4pkv6YAxg)]
 
## Abstracts:


### Neo4j in practice - everything that is left when the hype is over

Starting with basics of graph modeling, through the strangest design constraints, to good practices when modeling problems using graph databases. Next a look at how to query graph models, so a big portion of Cypher and indexes, query plans, hints and everything that is needed to write fast queries. We will end with some hints how to fit Neo4j into a multi persistent environment.


### <a name="whyDragonsNeedGraphs"></a> Why dragons need graphs / Graph databases - why and how

From graph theory through the history of computing and how it affected database design, to why relational databases aren't about relations.
Next, a look at how diverse the current graph database market and what obvious and not so obvious problems are solved by graphs. We will see how to launder money, suggest products, give answers to NLP tasks, build a knowledge base, balance a game economy and model mixed concept domains. A short introduction to Neo4j's query language, Cypher, will show the main concepts of querying graph data. Then, by use of the same datasets in both relational and graph databases will compare syntactic clarity and database performance.


### How I stopped worrying and learned to love parallel processing

Processing hundreds of gigabytes of data shows that old, known tricks don't work. Even more, they can significantly slow down processing. The problem gets even more complicated when it's individual steps are differently bound, have a different level of parallelization, and there are significant memory and CPU constraints. This talk will show problems I've had designing such a system and how using TPL Dataflow takes most of that pain away.


### Lessons learned building a large distributed system

With two of my coworkers, we shared some knowledge from designing and building a large distributed system. The project is a from scratch ERP system for a multinational company built with scalability and modularity in mind. We shared knowledge starting from high-level network architecture of out application, database servers and load balancers. Then we talked how we manage synchronous and asynchronous communication, modularity and data replication. The next part goes into how we used ASP.MVC and designed a domain language on top of it that allows us to auto create views, control serialization and implement nonfunctional requirements without the need to change existing business code. Going deeper takes us into how we modeled such concepts as multi-language text and  enumeration values using [NHibernate](http://nhibernate.info/), [Fluent NHibernate](http://www.fluentnhibernate.org/) and custom code. We ended with some tips how to manage the development of such a huge system and allow 45+ developers to work effectively.
