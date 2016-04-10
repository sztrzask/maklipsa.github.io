---
layout: post
title: The importance of running on crap
description: "Running on a crappy server isn't a bad thing."
modified: 2016-04-10
tags: cookit  
---


As a pet project, I’m running [cookit.pl](http://cookit.pl "cookit.pl") - a search engine for recipes, ingredients and food in general. 

I will be writing some more about the software side and all the problems I've encountered, but because [StackExchange published it's hardware setup](http://nickcraver.com/blog/2016/02/17/stack-overflow-the-architecture-2016-edition/) I also felt in need to share what is my hardware.

Let’s start with…

**Application services:**

- An IIS 8 hosted website,
- SOLR hosted on Tomcat as the search engine,
- SQL Server as the main source of truth ,
- a windows service for doing all the work (the website is almost in read only mode).

**Supporting applications:**

- [TeamCity](https://www.jetbrains.com/teamcity/) to run builds, test, health checks, and deploy.
- [Search everything](https://www.voidtools.com/), because Windows Search doesn't work to good when searching through almost 3 million images and 600 000 text files.
- [FastStone Photo Resizer](http://www.faststone.org/FSResizerDetail.htm) for batch image optimization, cropping and rescaling. 

**Some numbers**

- 550 GB of images,
- 584,834 dumped parse result files,
- ~ 110 000+ recipes,
- ~ 3000 ingredients,
- ~ 150 ms main page, and ~250 ms search results response time (this varies on what is going on on the server)

And all of this runs on, there is no better way of putting it, on
![crap](https://cdn0.iconfinder.com/data/icons/pixelo/32/poo.png) (with added RAM).

To be more specific on a i3-3250 CPU, 8 GB of RAM, and 1 TB hard drive (with write speed sometimes between 3-4 MB/sec).

Why don't I upgrade to a better server, or even better go to the cloud?

There are many reasons, but here are some of them:

- **I shouldn't need a better server**. The http load that cookit is taking isn't that big, so this machine should have plenty of computing power spare. This wasn't true in the past, but now it uses ~15% CPU and ~1GB of RAM.
- **It is auto testing my code**. Any performance problems will be visible much sooner. Basically if in the morning my mail isn't flooded with error logs, or any of my monitoring services didn't send me an auto alert, in most cases it means things are fine.
- **Fast is callable.** It isn't true in general, but it is easier to scale a fast application, then a slow one. Running on this machine gives me a lot of space to go up without any need for major code changes.
- **It is hard**. Running on crap is much harder than on an 8 core 32GB machine with SSD/nvme drives. It makes is easier to run into strange problems, and that means I have to learn more. And very often go outside of my comfort zone. That is a good thing.  
- Finally it turns out **crap if cheep**. And since I'm not making any money from it, spending little is nice.

