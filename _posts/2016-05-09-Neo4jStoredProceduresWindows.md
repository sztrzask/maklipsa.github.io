---
layout: post
title: Neo4j stored procedures for Windows
description: "A full how to get Neo4j stored procedures working on Windows, and fix 'There is no procedure with the name ...'."
modified: 2016-05-05
tags: [graph databases, Neo4j, Neo4j3.0, Neo4j stored procedures, stored procedures, how to]
image:
  feature: data/Neo4jStoredProcedures/StoredProcedures.png
---

In the [previous post I've written about new features in Neo4j](http://indexoutofrange.com/GraphConnectEurope/). 
One of the new game changing functions were stored procedures. But, as I experienced, getting them to run on a Windows / .NET environment wasn't that easy, and I was seeing "There is no procedure with the name ..." more often then I wished for.
So here is a short how to. Hope to save you some googling.


1. **JDK**

	1. Download and install JDK 8.x from [here](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html). I've used 8u92 version.
	
	2. Set environment variable for `JAVA_HOME` pointing to JDK install location (in my case `C:\Program Files\Java\jdk1.8.0_92`). This can be done with some PowerShell:
		<pre><code class="powershell">[Environment]::SetEnvironmentVariable("JAVA_HOME","C:\Program Files\Java\jdk1.8.0_92","Machine")
		</code></pre>
	
	The last parameter sets it as a machine level variable (visible for all users).
	 
2. **Install Maven**

	1. Download Maven from the [official site](https://maven.apache.org/download.cgi)
	2. Unzip it to a directory. In my case `C:\Program Files\Maven`
	3. Add environment variables for `M2_HOME` and `MAVEN_HOME`.
		<pre><code class="powershell">[Environment]::SetEnvironmentVariable("M2_HOME","C:\Program Files\Maven","Machine")<br/>
		[Environment]::SetEnvironmentVariable("MAVEN_HOME","C:\Program Files\Maven","Machine")
		</code></pre>

	4.  Update `PATH` environment.

		<pre><code class="powershell">
		$path=[Environment]::GetEnvironmentVariable("Path","Machine")<br/>
		if($path -notcontains "%M2_HOME%\bin"){<br/>
			&nbsp;&nbsp;&nbsp;$newPath=$path+";"+ "%M2_HOME%\bin"<br/>
			&nbsp;&nbsp;&nbsp;[Environment]::SetEnvironmentVariable("Path",$newPath,"Machine")<br/>
		}<br/>
		</code></pre>

	5.  Check. Run `mvn -version` in a new cmd.
  
3. **Neo4j**

	1. If you haven't, download the new Neo4j version (stored procedures are available in version 3.0 and up) from [here](http://neo4j.com/download/).
	2. Add `NEO4J_HOME` environment path for Neo4j folder(in my case `C:\Program Files\Neo4j CE 3.0.0`).
		<pre><code class="powershell">[Environment]::SetEnvironmentVariable("NEO4J_HOME","C:\Program Files\Neo4j CE 3.0.0","Machine")
		</code></pre>
	3. Clone `neo4j-apoc-procedures`. Again some PowerShell - 
should be executed with admin privileges:
		<pre><code class="powershell">git clone http://github.com/jexp/neo4j-apoc-procedures<br/>
		cd neo4j-apoc-procedures<br/>
		mvn clean install<br/>
		copy target/apoc-1.0.0-SNAPSHOT.jar $Env:NEO4J_HOME/plugins/ 
		</code></pre>
	4. Edit Neo4j config.
	
		Open `%userprofile%\AppData\Roaming\Neo4j Community Edition` and add this entry (**change the path if yours was different then in point 3.1**):

		`dbms.directories.plugins=c:/Program\ Files/Neo4j\ CE\ 3.0.0/plugins`
		
	5. Restart Neo4j (if it was running)
	6. Check if it is OK and enter for example `call apoc.help('search')` in Neo4j cmd. And this should appear:
 	![Neo4j stored procedures working](/data/Neo4jStoredProcedures/StoredProceduresWorking.png)