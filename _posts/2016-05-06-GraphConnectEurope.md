---
layout: post
title: Graph Connect Europe 2016
description: "Graph Connect Europe is over, and "
modified: 2016-05-04
tags: [graph databases, Neo4j, Neo4j3.0, conference]
image:
  feature: data/GraphConnect2016/GrahConnect.png 
---
Last week I had the opportunity to attend [Graph Connect Europe](http://graphconnect.com/). Many great sessions, but one thing topped them all - [Neo4j 3.0 is out](http://neo4j.com/release-notes/neo4j-3-0-0/)!

And as with previous major release (it introduced [Cypher](http://neo4j.com/developer/cypher-query-language/)) there are many bug fixes, tweaks, speed improvements, but here are my personal favorites:

- **Stored procedures**.... Yeah I know I've lost you there. But those aren't yours father's stored procedures. Neo4j now enables to call any JVM custom function from Cypher. To start with, they published a [repo with 99 procedures called apoc](https://github.com/neo4j-contrib/neo4j-apoc-procedures) (and if 'apoc' sounds familiar, yes it's a Matrix reference). It doesn't make any sense to describe all of them since they are all quite well described in the GitHub repo, but just to point out the more awesome ones:
	- [**Meta Graph**](https://github.com/neo4j-contrib/neo4j-apoc-procedures#meta-graph) - to be exact `apoc.meta.graph`. This procedure analyzes the whole graph and creates a meta-graph showing what node types have what relations with each other. For me a great one for exploring an unknown Neo4j database, or just to check if we didn't screw up any relations. 
	
		To have a look how it looks lets fire the `:play movie graph` in Neo4j cmd. It displays a widget with couple steps. The code generating the database is on the second screen. After executing the graph should look like this:

		![](/data/GraphConnect2016/MovieDatabase.png)
	 
		As You can see in the top left corner it has nodes labeled `Movie` and `Person` and relations named `ACTED_IN`, `DIRECTED`, `DIRECTED`,`FOLLOWS`,`PRODUCED`,`REVIEWED`, `WROTE`.<br/>
		So lets see meta graph:

		![](/data/GraphConnect2016/MovieDatabase_metagraph.png)
		
		This graph is a XXXXS size, but with 171 nodes and 253 relations it is hard to gasp it's structure. The meta graph makes it extremely simple and easy.
	
	- [**Loading data from RDBMS**](https://github.com/neo4j-contrib/neo4j-apoc-procedures#loading-data-from-rdbms) - It enables to connect to any database supporting JDBC connector.<br/>
	What is even more is the syntax:
		`CALL apoc.load.jdbc('jdbc:derby:derbyDB','PERSON') YIELD row CREATE (:Person {name:row.name})` <br/>
	for loading the whole table, or<br/>
		`CALL apoc.load.jdbc('jdbc:derby:derbyDB','SELECT * FROM PERSON WHERE AGE > 18')`<br/>
	for executing any SQL statement. 
  
- **Bolt**. A binary protocol for communicating with Neo4j. Because not long ago [Ayende with Raven](https://ayende.com/blog/173890/the-design-of-ravendb-4-0-over-the-wire-protocol) also announced they are moving to a binary protocol. For me it is a good signal. It means that those databases are maturing and HTTP overhead,which for millisecond operations can be bigger than time spend actually executing the query, is starting to be an issue. This would be a problem, because binary protocols are harder to implement drivers if not for the next announcement:
 
- **Official drivers.** For Java, JavaScript, Python and **.NET :)**. The syntax looks simple, but clear:
<pre><code class="csharp">using (var driver = GraphDatabase.Driver("bolt://localhost"))
using (var session = driver.Session())
{
   var result = session.Run("MATCH (u:User) RETURN u.name");
}
</code></pre>

- **No node limit.** This may seem like a big thing (and probably was from implementation perspective), but previously the limit was 34 bilion nodes. So it wasn't a real limit for most cases. But good to know:)
   
- **GUI changes.** When You click on any node in the graph options will appear: 
	![](/data/GraphConnect2016/NodeOptions.png)

	So what do these buttons do?

	- **x** - removes the node from view (not from the database)
	- **lock** - locks this node into position, so it won't move when the graph is expanded.
	- **arrows** -  it shows all relations and nodes connected to this node. So from the above we get:
	
	![](/data/GraphConnect2016/NodeExpanded.png)
 	
	And if we expand Joel Silver we get this:

	![](/data/GraphConnect2016/NodeExpanded2.png)
	 
	And so on and so on. You get the point. Why is it cool? Because it allows to actualy walk the graph and explore it. Imagine debugging Minority Report style (only without the gloves, the screen, and being Tom Cruse)
	
	<iframe width="560" height="315" src="https://www.youtube.com/embed/PJqbivkm0Ms" frameborder="0" allowfullscreen></iframe>

It doesn't mean that those are all the features. If you got hooked go check [Neo4j 3.0 blogpost on the official blog](http://neo4j.com/blog/neo4j-3-0-massive-scale-developer-productivity/).