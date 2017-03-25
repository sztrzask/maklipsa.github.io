---
layout: post
title: The not so obvious complexity of key value databases
description: ""
series: "databases"
tags: [Redis, database, key-value]
image:
  feature: data/2017-03-27-The-not-so-obvious-complexity-of-key-value-databases/logo.jpg
---


The [previous post](/What-is-the-simplest-database/) laid out the minimal requierments for a database. While they may be to minimalistic for many, there is a lot of databases that don’t meet them.

This time splice things a bit and look at a bit complex databases - key-value databases

<!--MORE-->

# The idea

The idea behind key-value databases is very simple:

`Store and retrieve objects based on a key.`
 
There are many complex problems underneeth, but let’s first look at what this simplicity gives us.

# Why use a key-value database?

## Speed

If You are thinking that it is the same as an index lookup in a relational database, keep on reading because You are very wrong, an order of [big **O**](https://en.wikipedia.org/wiki/Big_O_notation) wrong.

Indexes in relational databases are implemented using a [B-Tree structure](https://en.wikipedia.org/wiki/B-tree) that looks like this:

![](/data/2017-03-27-The-not-so-obvious-complexity-of-key-value-databases/B-tree.png)

> This is one of the most fundamental structures for modern computer science, and if You don’t know it please read [this Wikipedia page](https://en.wikipedia.org/wiki/B-tree). It will be a time well spend.

While this is an amazing structure it has to obey the rules of mathematics when it comes to cost of search:

O(log(n/m))

where:

- n is the total number of elements
- m - number of elements in a single node.

To contrast it, key-value databases use a hashing function to determine the position of the element in the index. It's cost is:

O(1)

You can't get any better than this.

## Simplicity

If something is simple it breaks less often, is easier to maintain and to reason about. Without it we wouldn't have the next point. 

## Horizontal scaling

Because in this model of a database:

- the key is the only way to identify a value
- hash function transforms the key into an integer in a deterministic way 
- we aren't doing any aggregate operations
- update always updates the **whole** value (the database doesn't know anything about the schema of the value)

This makes it very easy to horizontally scale such a solution. In the most simplistic way:

`hash(key) % NUMBER_OF_SERVERS`

# What not to expect from key-value databases

If You have been living in RDMS land here are some things not to look for in key value databases:

## Transactions

It is very rare to see them in key-value databases. Instead we have `atomicity`. What is the difference?

- **Atomicity** - means that the operation will execute or not. In short, in case of failure we won't up with corrupted data.
- **Transaction** - a series of multiple operations will execute atomicity as one.

Is this a problem? No. Let's examine why:

- `complex statements flows` - the need for it happens when the data of one key contains keys that should be, for example, deleted. This means that there is a relation, and this means that we are trying to do a RDMS on top of a key-value database, and this is not a good idea. 
- `SELECT` - no need for transactions. We ask for an element and get it back.
- `DELETE`- single `DELETE` is atomic. The problem may be with deleting multiple objects. Let's examine the case. It all boils down to the fact how did we get the keys of the elements to delete?
 
	- If we got the from a value in the database than we have the case of the `complex statements flows` from above. 
	- If we want to delete values which keys fulfil some patter than just retry the delete.        

# Problems

As mentioned before, there are some not so simple problems when dealing with key-value databases. Below are some of them:
 
### Collision resolution

Hash functions transforms any key into a number, so an element from a limited collection. 
 
### Cluster rescalling

## Examples

While those are very simple databases they differ quite strongly. To show that let's examine [3 most popular key-value databases according to db-engines](). 

![](/data/2017-03-27-The-not-so-obvious-complexity-of-key-value-databases/memcached.jpg){: .logo}

## Memcached

I'm starting from the third place and also from the oldest database in the ranking (initial release in 2003).
Memcached is not exactly a database since it's main feature is auto deleting data. Think of it as a huge, fixed size, cache with auto deletion of items based on a FIFO. All items are stored in the memory, and there is no way to persist it (but let's face it: there is no sense for persistance if the database can delete the data at any time).

Since Memcached is a cache store it has some limits on key and value sizes:

- key: up to 250 bytes
- value: up to 1MB

To know more take a look at the summary table at the end.

To sum up the must-haves:

- [ ] **ability to reliably persist data** - Memcached will auto delete the oldest data, so this point is out. Also we are talking about a database that stores everything in memory, so let's not call it *reliable persistance*.
- [x] **ability to reliably retrieve data** - If the data wasn't deleted it will be returned.
- [ ] **ability to delete data** - This is a cache and it takes care of deleting.

To sum up the should-haves:

- [ ] **ability to query data** - We can't do any matching on keys.
- [x] **ability to update data** - We can update the whole value. No partial updates. 
- [ ] **has transactions** - No the case in this databases.   

![](/data/2017-03-27-The-not-so-obvious-complexity-of-key-value-databases/riak.png){: .logo}

## Riak

Implements [Amazon Dynamo paper](http://www.allthingsdistributed.com/files/amazon-dynamo-sosp2007.pdf) 

### Multi-datacenter replication

In multi-datacenter replication, one cluster acts as a "primary cluster." The primary cluster handles replication requests from one or more "secondary clusters" (generally located in other regions or countries). If the datacenter with the primary cluster goes down, a second cluster can take over as the primary cluster.
There are two primary modes of operation: fullsync and realtime. In fullsync mode, a complete synchronization occurs between primary and secondary cluster(s), by default every six hours. In real-time mode,replication to the secondary data center(s) is triggered by updates to the primary data center. All multi-datacenter replication occurs over multiple concurrent TCP connections to maximize performance and network utilization.
Note that multi-datacenter replication is not a part of open source Riak.

- no transaction
- no partial updates
- no search for keys
- REST interface
- siutable for storing binary data
- [problems with deletes](https://www.trustradius.com/reviews/riak-2015-12-01-11-11-07)
- the ability to choose between Strong Consistency and Eventual Consistency
- [ ][Build-in Full text search with Solr](https://www.g2crowd.com/products/riak/reviews)
- [ ]last write wins 
- [ ]Cluster is setup as a ring
- No Windows support
- Persistent
- [ ]Map reduce
- 

![](/data/2017-03-27-The-not-so-obvious-complexity-of-key-value-databases/redis.png){: .logo}

## Redis

## Architecture 

- One thread
- pattern search for keys (returns only keys, that have to be than fetched)
- TCP/IP interface
- [ ] max value size/max key size
- cluster is a all connected system
- Lua scripting

### Redis cluster

Redis Cluster is **not able to guarantee strong consistency**.
In practical terms this means that under certain conditions it is possible that Redis Cluster will lose writes that were acknowledged by the system to the client.
The first reason why Redis Cluster can lose writes is because it uses asynchronous replication. This means that during writes the following happens

In Redis Cluster nodes are responsible for holding the data, and taking the state of the cluster, including mapping keys to the right nodes. Cluster nodes are also able to auto-discover other nodes, detect non-working nodes, and promote slave nodes to master when needed in order to continue to operate when a failure occurs.

Since cluster nodes are not able to proxy requests, clients may be redirected to other nodes using redirection errors -MOVED and -ASK. The client is in theory free to send requests to all the nodes in the cluster, getting redirected if needed, so the client is not required to hold the state of the cluster. However clients that are able to cache the map between keys and nodes can improve the performance in a sensible way.

### Rehashing
`MOVED` exception. 


# Comparison

|---
| Option          		| Memcached 	| Riak	| Redis	| 
|:----------------------|:--------------|:------|:------|
| Key limits      		|250 bytes 		|		|		|
| Value limits    		|1 MB      		|		|		|
| Connection protocol	|TCP/IP			|		|		|
|**Cluster**			|				|		|		|
| Cluster info			|client knows all servers in cluster| | | 
| Cluster architecture	|share nothing	|		|		|
| Run on				|Windows/Linux/Unix|		|		|
| Main features			|auto deletion of data|			|			|
| Build for				|cache server	|		|		|

## Drawbacks

### In memory
### Large objects

## Further reading:

- [HyperLogLogs data structure - Wikipedia](https://en.wikipedia.org/wiki/HyperLogLog) 
- [Very good analysys of HeyperLogLogs algorythm](http://antirez.com/news/75)
- [Redis cluster documentation](https://redis.io/topics/cluster-tutorials)
- [Collision resolution](https://en.wikipedia.org/wiki/Hash_table#Collision_resolution)
- [Top Level analysys of Redis architecture](http://key-value-stories.blogspot.com/2015/01/redis-core-implementation.html) and a [conversation on Redis google group](https://groups.google.com/forum/#!topic/redis-dev/blzNXKjsBCk)
- [Riak reviews](https://www.g2crowd.com/products/riak/reviews)
- [Most popular Key-value databases comparison on db-engines.com](http://db-engines.com/en/system/Memcached%3BRedis%3BRiak+KV)
- [Very good Memcached Wikipedia page](https://en.wikipedia.org/wiki/Memcached)


TODO:
- dopisać się tu:http://stackoverflow.com/questions/37059609/what-are-riak-advantages-for-redis-key-value-store

<style>
div.entry-content .logo{
    height:150px;
}
</style>