---
layout: post
title: Why dragons need graphs - demo files
description: "Demo files for my talk on state on graph databases, with demos with Neo4j"
modified: 2016-05-04
tags: [talk, graph databases, Neo4j]
---

This describes the content of a [zip package](/data/why-dragons-need-graphs.zip) containing demo files from my talk **Why dragons need graphs**.
There are two folders containing a create script and some query scripts showing basic, and more advanced syntax of Neo4j Cypher.
<!--MORE-->

### Dragons
Demoes basic syntax of Cypher.

* `00_Create.txt` - Graph creation script
* `01_SelectAllNodes.txt` - Displays all nodes. Neo4j by default shows all edges, so it will show the whole graph.
* `02_SelectAllNodesConnectedToMonster.txt` - Demonstrates how to filter nodes type.
* `03_SelectAllNodesConnectedTo.txt` - Adds edge type filtering.
* `04_MultipleSelect.txt` - Shows how to select multiple nodes by multiple filters.
* `05_SelectStrongestMonster.txt` - Using two way relations (from left to right, and right to left), multiple edge and node filtering selects the strongest monster.
* `06_ShortestPath.txt` - Uses Neo4j shortestPath and shortestPaths to select shortest paths between nodes.

### Text recognition
A very simplified example how graphs can be used in text recognition tasks. It gives the answer to the sentence:

> Sushi restaurants in New York that my friends like

All select scripts are additive (they extend the previous one)

* `00_Create.txt` - Graph creation script
* `01_SelectMe.txt` - Selects node responsible for 'me' 
* `02_SelectFriendsFoMe.txt` - Selects my friends
* `03_SelectSushi.txt` - Selects 'sushi' food type
* `04_SelectSushiRestaurants.txt` - Selects sushi restaurants
* `05_SelectRestaurantsThatMyFriendsLike.txt` - Selects sushi restaurants that my friends like.
* `06_SelectRestaurantsInNewYork.txt` - Narrows the restaurants to those in New York.
* `selectAll.txt` - Selects all edges.

**Update**
And the video:

<iframe width="560" height="315" src="https://www.youtube.com/embed/Bo6uOQ-P25w" frameborder="0" allowfullscreen></iframe>