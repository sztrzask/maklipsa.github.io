---
layout: post
title: What is the simplest database?
description: "You almost can't go simpler than key-value databases, but even them are more complex than they seem"
modified: 2017-03-20
tags: [databases, architecture, key-value, analysis, comparison]
image:
  feature: data/2017-03-20-What-is-the-simplest-database/logo.jpg
---

The world of databases is a fascinating topic. It is very diverse, many of them are extremly complex systems, but there are also very simple ones. Thy are the general purpuse ones, and ones that do only one thing good, but they do it excelent. Despite all of this we tend to pick them just like we order food in a restaurant:

- I'll take the same as last time. It wasn't ideal for what I wanted, but I could pick worse.
- Hmm... Everyone is taking this one so I'll take it also.

Well maybe it is time to dig deeper into it?

<!--MORE-->

## Preface 

I'm writing this post in addition to my [You are using the wrong database!](https://indexoutofrange.com/speaking/cfp/You-are-using-the-wrong-database!/) talk which intention is to show:

- how important is picking the right database and how strongly it affects the whole system
- how diverse is the world of databases
- why the most common criterium for choosing: "I'll use what I know" sucks, to put it lightly.

## Definition

This is the place normally filled by a copy and paste from Wikipedia, but let's create a definition on a more look and feel approach. 
I'll divided them into two parts: **must haves** and **should haves**. Here we go:

### Must have

Those points are what, for me, defines a database. The basic functionalities that make a product a database:

- **ability to reliable persist data** - kind of a no-brainer, but this paragraph is just for that. 
- **ability to reliable retrieve data** - there is little use for a database that can only accept data, but can't retrieve it. This point requiers that we get back a single element that is identified by it's key. 
- **ability to delete data** - I have insert and select, so the only one missing is a delete. 

Only three points? Yes, but remember, we are talking about the must haves.

### Should haves

So this is where I put all the theoretical features mumbling? Not exactly, here are my **should haves**:

- **ability to query data** - how this one differs form the previous ability to retrieve data? There we identified the data using a single key. Here we are requiering the ability to return list of stored data that meets certain parameters. Think of it as the WHERE clause from SQL.
- **ability to update data** - this in theory can be achieved by deleting and inserting a new record, but this implementation fails quite fast when taking into account a bit more advanced features. This point requiers that I am able to change data without side effects, such as change in the auto generated id.
- **has transactions** - I am not talking here about the more advanced isolation levels, but the simple fact that if something failes while executing the operation my database won't get corrupted.

## The simplest database

Go on have a guess. What is the simplest database that fullfiles all the must haves and almost all should haves.

Are You sure You know? Think again, but if You are certain click

### File is the simplest database {: .regIco}

Did You get it right? Let's got through the lists.
**Must haves:**

- [x] **ability to reliable persist data** - calling `fsync` will make sure that the file was written to the hard drive and the hard drive is what we think when talking about persistent storage.  
- [x] **ability to reliable retrieve data** - You can read a files contents.
- [x] **ability to delete data** - once again, a simple delete.

**Should haves:**
  
- [x] **ability to update data** - We can update a file right? We can even do a partial update thanks to the ability to start writing from a certain index.
- [x] **has transactions** - A pass? Files have transactions. Yes. [Windows even has support for distributed transactions](https://msdn.microsoft.com/en-us/library/windows/desktop/aa363764(v=vs.85).aspx). This means that you can combine saving a file with update in a database in an external server. Anyone who worked with distributed transaction knows that they should be avoided, but in some cases it is not possible.
- [x] **ability to query data** - We can query files by their name, content and directory structure. As You will see in the later posts this is more that some databases offer.  

 