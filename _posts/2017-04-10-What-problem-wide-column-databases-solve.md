---
layout: post
title: What problem wide column databases solve?
description: ""
modified: 2017-04-10
series: "databases"
tags: []
image:
  feature: data/2017-04-10-What-problem-wide-column-databases-solve/logo.jpg
---

[Previously I've wrote about key-value databases](/Want-unlimited-scale-and-performanceThis-is-where-to-start/). They are awesome - ultra fast, simple, can scale almost linear to the number of nodes. So why bother with complicating them?

Well, they have some issues.
 
<!--MORE-->

# Problems with key-value databases

The main concept of a key-value database is that the database doesn't care what is the value. It may have [some assumptions, like Redis,](/Want-unlimited-scale-and-performanceThis-is-where-to-start) but the structure of the data is not of it's interest. This leads to some limitations that can be problematic in some scenarios.

## 1. Can't filter on value fields

This is quite obvious since from the database point of view value is a blob.

## 2. The whole value is returned

On the first thought this may not seem as a problem, but remember that key-value databases are chosen for speed of returning the data. When looking at a flow of retrieving data from a database:

![](/data/2017-04-10-What-problem-wide-column-databases-solve/database-request-flow.png){: .center-image }

It becomes obvious that most of the steps are performance dependent from the **size of the data transmited, not the data actually used** (this is why `SELECT *` is a sign of someone not giving a f**k about performance).  
 
## 3. The value can be updated only as a whole

This is a problem because we have to:

- get the whole data to the client (see point above)
- operate on the whole data
- send the whole data back to the database

This may not sound bad, even good. We want to have the whole object when updating it, right? 

Think about those cases:

- update users last login date
- append element to the list (like online checkout basket)
- change the prices on certain products because of a promotion

<br/>
<br/>
<p class="center-text" ><b> So how to solve those problems and not loose all that speed? </b></p>
<br/>
<br/>

# Wide column databases

The idea behind it is simple:

`Let's structure data (that is the value part) again into key-value pairs.`

This is hat we have in key-value databases:

![](/data/2017-04-10-What-problem-wide-column-databases-solve/key-value.png){: .center-image }

This is how wide column databases represent data:

![](/data/2017-04-10-What-problem-wide-column-databases-solve/wide-column.png){: .center-image }

This allows to define a subset of columns we want to return to the client, or columns that should be updated.

## How is it different from a normal table in a relational database?

In most wide column databases the columns are defined on the **single item level**, meaning there is no schema.
This leads to a very interesting feature of wide column databases:

## Benefits from wide column databases 

While wide column databases keep most of the [perks of key-value databases mentioned previously](/Want-unlimited-scale-and-performanceThis-is-where-to-start/) they have some additional ones (They don't have to exist in every implementation of a wide-column database, but most of them have it):

- **partial operations** (add column value, update column value).
- **data compression**. When dealing with sparse data we don't have to store empty/null values. This way we can save space normally reserved because schema defined them.

In the next post a sample domain modeling using a wide-column database. 

<style>
.center-image
{
    margin: 0 auto;
    display: block;
}
.center-text{
	text-align: center;
	font-size: 1.5em;
}
</style>

