---
layout: post
title: Think You know something about key-value databases?
description: ""
series: "databases"
tags: [Redis, database, key-value]
image:
  feature: data/2017-03-27-The-not-so-obvious-complexity-of-key-value-databases/logo.jpg
---


The [previous post](/What-is-the-simplest-database/) laid out the most minimal requierments for something to be called a database. While they may be to bare bones for many there are a lot of databases that don't fulfil even half of them, and we are still using them on daily basis.

The last time I've looked at files, this time something a bit more complex - key-value databases.

<!--MORE-->

# The idea

The idea behind key-value databases is very simple:

`Store and retrieve objects based on a key.`

So we are saying goodbye to:

- tables and columns - everything is a blob
- relations
- in most cases any typing of data - it is ether a bite array or a string
- complex operations 

This is a lot, what do we gain?

# Why use a key-value database?

## Speed

If You are thinking that getting the object from a key-value database is more or less the same as a index lookup in a relational database, keep on reading because You are very wrong, an order of [big **O**](https://en.wikipedia.org/wiki/Big_O_notation) wrong.

Indexes in relational databases are implemented using a [B-Tree structure](https://en.wikipedia.org/wiki/B-tree) that looks like this:

![](/data/2017-03-27-The-not-so-obvious-complexity-of-key-value-databases/B-tree.png)

> This is one of the most fundamental structure for modern computer science. If You don’t know it please at least read [this Wikipedia page](https://en.wikipedia.org/wiki/B-tree). It will be a time well spend.

While this is an amazing structure it has to obey the rules of mathematics when it comes to cost of search:

`O(log(n/m))`

where:

- n is the total number of elements
- m - number of elements in a single node.

To contrast it, **most** key-value databases store the data in memory, so they can use a hashing function to determine the position of the element in the array. It's cost is:

`O(1)`

You can't get any better than this.

## Simplicity

If something is simple it breaks less often, is easier to maintain and to reason about. Without this simplicity we wouldn't have the next point. 

## Horizontal scaling

These rules:

- the key is the only way to identify a value
- hash function transforms the key into an integer in a deterministic way 
- we aren't doing any aggregate operations
- update always updates the **whole** value (the database doesn't know anything about the schema of the value)

This makes it very easy to horizontally scale such a solution. In the most simplistic way:

`hash(key) % NUMBER_OF_SERVERS`

This is an oversimplification, but some key-value databases actually use it. 

# What not to expect from key-value databases

If You have been living in RDMS land here are some things not to look for in key value databases:

## Transactions

It is very rare to see them in key-value databases. Instead we have `atomicity`. What is the difference?

- **Atomicity** - means that the operation will execute or not. In short, in case of failure we won't up with corrupted data.
- **Transaction** - a series of multiple operations that will execute atomicity as one.

Is the lack of transactions a problem? No. Let's examine the cases when we would actually use them:

- `SELECT` - no need for transactions. We ask for an element and get it back.
- `DELETE`- single `DELETE` is atomic, so no problem here. The need could arrive when doing multiple deletes. This case boils down to the fact how did we get the keys of the elements to delete?
 
	- If we stored those keys as a value of another key - go to the `complex statements flows`.
	- If we want to delete values which keys fulfil some patter than just retry the delete.        
- `UPDATE` - the same as with `DELETE`.
- `complex statements flows` - the need for it happens when the value of one key contains keys that should be, for example, deleted. This means that there is a relation, and this means that we are trying to do a RDMS on top of a key-value database, and this is not a good idea. 

## Examples

While those are very simple databases they differ quite strongly. To show that let's examine [3 most popular key-value databases according to db-engines](http://db-engines.com/en/ranking/key-value+store). 

<br/>
<br/>

![](/data/2017-03-27-The-not-so-obvious-complexity-of-key-value-databases/memcached.jpg){: .logo}

## Memcached

> Designed for: **cache**

I'm starting from the third place and also from the oldest database in the ranking (initial release in 2003).
Memcached is not exactly a database since it's main feature is auto deleting data. Think of it as a huge, fixed size, cache with auto deletion of items based on a FIFO. All items are stored in the memory, and there is no way to persist it (but let's face it: there is no sense for persistance if the database can delete the data at any time).

Since Memcached is a cache store it has some limits on key and value sizes:

- key: up to 250 bytes
- value: up to 1MB

### Must-haves:

- [ ] **ability to reliably persist data** - Memcached will auto delete the oldest data, so this point is out. Also we are talking about a database that stores everything in memory, so let's not call it *reliable persistance*.
- [x] **ability to reliably retrieve data** - If the data wasn't deleted it will be returned.
- [ ] **ability to delete data** - This is a cache and it takes care of deleting.

### Should-haves:

- [ ] **ability to query data** - We can't do any matching on keys.
- [x] **ability to update data** - We can update the whole value. No partial updates. 
- [ ] **has transactions** - No the case in this databases.   

<br/>
<br/>
![](/data/2017-03-27-The-not-so-obvious-complexity-of-key-value-databases/riak.png){: .logo}

## Riak

> Designed for: key-value database synchronized accros multiple data centers
 
The second place is taken by Riak, which is a implementation of [Amazon Dynamo paper](http://www.allthingsdistributed.com/files/amazon-dynamo-sosp2007.pdf). Riak is a completely different beast than Memcached and was build to solve different problems. It's a distributed, cross data center, persistent key-value database aiming for availability, even at the cost of consistency. The above statement contains a lot of information, so let's decompose.

### Data types

As I wrote before key-value stores don't care about the schema of stored objects, but they have special purpouse data types. In Riak case its:

- [`Flags`](http://docs.basho.com/riak/kv/2.2.1/developing/data-types/maps/#flags) - true/false values. Can only be used inside a map type.
- [`Registers`](http://docs.basho.com/riak/kv/2.2.1/developing/data-types/maps/#registers) - named binaries. Also can only be used inside a map 
- [`Counters`](http://docs.basho.com/riak/kv/2.2.1/developing/data-types/counters/) - as the number suggests incremented integers. Can be used in a map and as a value on its own. 
- [`Sets`](http://docs.basho.com/riak/kv/2.2.1/developing/data-types/sets/) - collection of binary values. Similar to the Counter type can be used on its own and in a map. 
- [`Maps`](http://docs.basho.com/riak/kv/2.2.1/developing/data-types/maps/) - collection of values. Differently than Sets they can contain other data types, even other maps. 
- [`HyperLogLog`](http://docs.basho.com/riak/kv/2.2.0/developing/data-types/hyperloglogs/) - a propabilistic structure for checking cardinality of a set.

### Clustering

Riak supports clustering with tunnable consistensy. How is it done? Since the cluster is a ring architecture, like this:

![](/data/2017-03-27-The-not-so-obvious-complexity-of-key-value-databases/riak-ring.png)  

Tuning the level of consistensy is done by defining how many nodes have to accept the operation before it's confirmed (default is 3). 

Riak cluster has very interesting properties:

- no master nodes (it is a characteristic of ring clusters).
- any node can accept write for any key (no master node for a given hash value).
- allows simultanious writes to a single key.

This leads to the need for conflict resolution. Riak documentation suggests using custom types, since conflict resolution works better with them. In case of not defined types we have [multiple possibilities](http://docs.basho.com/riak/kv/2.2.1/developing/usage/conflict-resolution/): [timestamp](http://docs.basho.com/riak/kv/2.2.1/developing/usage/conflict-resolution/#timestamp-based-resolution), [last-write-wins](http://docs.basho.com/riak/kv/2.2.1/developing/usage/conflict-resolution/#last-write-wins) and [on the application side](http://docs.basho.com/riak/kv/2.2.1/developing/usage/conflict-resolution/#resolve-conflicts-on-the-application-side). This works most of the time, but there have been people complaining about [Riak resurecting deleted keys even days after deletion](https://www.trustradius.com/reviews/riak-2015-12-01-11-11-07). Apparently it is better to set a custom `Deleted` flag than to delete.
 
### Must-haves:

- [x] **ability to reliably persist data** - This is one of the main points of Riak
- [x] **ability to reliably retrieve data** - Since Riak consistency is tunable this point is also partly passed. 
- [x] **ability to delete data** - works, although [resurecting deleted items is a reported problem](https://www.trustradius.com/reviews/riak-2015-12-01-11-11-07).

### Should-haves:

- [ ] **ability to query data** - We can't do any matching on keys, although it supports key searches using Solr.
- [x] **ability to update data** - No partial updates  
- [ ] **has transactions** - No transaction support.

<br/>
<br/>
![](/data/2017-03-27-The-not-so-obvious-complexity-of-key-value-databases/redis.png){: .logo}

## Redis

> Designed for: speed

The number one should not be a shock to anyone. Redis is, as the full name suggests, a  **RE**mote **DI**ctionary **S**erver. Over the years it has grown a few functions more than it's oryginal purpuse, but it still is a memory key-value dictionary.

### Architecture

I must say I like how well thought out Redis concepts are, and how it builds powerful features using it's basic rules.
Redis show that simplicity is speed. It runs on one thread and hosts only one database. To run multiple databases, run multiple Redis servers. Other important thing to note is that it is mainly a in-memory store with *optional* persistance:

- 

Thanks to the idea that *everything is a string* Redis exposes a interface for manipulating the values right on the database, without the need to send them to the client.  
One last thing to note is that Redis has the option to write Lua scrips.

### Data structures

Redis, similarly to Riak implements custom data structure, but non structured data is stored as a string, not as binary. Custom data structures are:

- `Binary-safe strings`
- `Lists` - collections of string elements sorted according to the order of insertion. Implemented as linked lists
- `Sets` -  collections of unique, unsorted string elements.
- `Sorted sets` - similar to `Sets` but every string element has a score(floating number). The elements are always taken sorted by their score, so unlike Sets it is possible to retrieve a range of elements (for example: the top 10, or the bottom 10).
- `Hashes` - maps composed of fields associated with values. Both the field and the value are strings.
- `Bit arrays` - allows to set, clear, count and find the first set or unset bit.
- `HyperLogLogs` - the same as in Riak

### Clustering

Redis is taking a different approach to clustering than the previous two:

- all nodes are connected
- values are automaticly shared on multiple servers
- has the concept of master datasets
- it does not guarantee [strong constistency](https://redis.io/topics/cluster-tutorial)
- client should hold a routing table for a cluster
- cluster is a self healing one. It can detect not responding and new nodes      
- nodes do not proxy requests. This means that if we request a key not present on the current node the server will return `MOVED` command to the client.
- multi node commands and Lua scripts are limited to near keys (no cross server operations)
- replication is anychronius
- one node should server 

### Pub-sub


## Architecture 

- pattern search for keys (returns only keys, that have to be than fetched)
- [ ] max value size/max key size
- cluster is a all connected system
- Lua scripting

### Redis cluster

Redis Cluster is **not able to guarantee strong consistency**.


# Comparison

|---
| Option          		| Memcached 	| Riak	| Redis		| 
|:----------------------|:--------------|:------|:----------|
| Key limits      		|250 bytes 		|No limit|			|
| Value limits    		|1 MB      		|No limit|512 MB	|
| Persistent			|No				|Yes	|			|
| Connection protocol	|TCP/IP			|HTTP	|TCP/IP		|
| Key scans				|No				|No*	|Yes		|
| Scripting				|No				|No		|Yes(Lua)	|
| Data schema			|No				|Yes	|			|
| Data is stored as a	|binary			|binary	|string		|
| 						|				|		|			|
|Licence				|BSD 3-clause	|Apache 2|BSD 3-clause|
|**Cluster**			|				|		|			|
| Cluster info			|client knows all servers in cluster| | |
| Cluster architecture	|share nothing	|ring	|		|
| Consistency			|Doesn't apply	| Tunnable from eventual to strong|			|
| Replication			|No				|Configurable|Async	|		
| Multi data center sync|No				|Yes	|		|
| Run on				|Windows/Linux/Unix|Linux		|		|
| Main features			|auto deletion of data|			|			|
| Build for				|cache server	|Key-value store accros multiple data centers|		|


legend:

- `*` - it has support for search using Solr


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