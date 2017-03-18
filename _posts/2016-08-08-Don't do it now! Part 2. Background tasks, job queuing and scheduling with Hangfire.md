---
layout: post
title: Don't do it now! Part 2. Background tasks, job queuing and scheduling with Hangfire
description: ""
modified: 2016-08-08
tags: [.NET, Hangfire, cookit, architecture]
series: "Don't do it now!"
image:
  feature: data/2016-08-10-Dont-do-it-now!Part-2.Background-tasks-job-queuing-and-scheduling-with-Hangfire/logo.png
---

This is the second part of a series discussing job scheduling and Hangfire details:

- [part 1 - Why schedule and procrastinate jobs?](/Don't-do-it)
- [part 2 - Overview of Hangfie](/Don't-do-it-now!-Part-2.-Background-tasks,-job-queuing-and-scheduling-with-Hangfire/)
- [part 3 - Scheduling and Queuing jobs in Hangfire](/Don't-do-it-now!-Part-3.-Hangfire-details-jobs/)
- [part 4 - Dashboard, retries and job cancellation](/Don't-do-it-now!-Part-4.-Hangfire-details-dashboard,-retries-and-job-cancellation/)
- [part 5 - Job continuation with ContinueWith](/Don't-do-it-now!-Part-5.-Hangfire-job-continuation,-ContinueWith/)
- [part 6 - Recurring jobs and cron expressions](/Don't-do-it-now!-Part-6.-Hangfire-recurring-jobs/)

In the [previous post](/Don't-do-it) I've written about why I think the ability to schedule tasks for later execution is a fundamental technical feature, but also a must have from business' point of view.
We are passed the *whys*, so let's get to the *hows*. The answer is simple - Hangfire. I've written about it [here](http://indexoutofrange.com/GC-can-kill-You-Practical-GC-performance-counters-in-NET/), [here](http://indexoutofrange.com/LocalOptimizationsDontAddUp/) and [here](http://indexoutofrange.com/How-is-cookit-build/), so yeah, you guessed it, I like it.  Hangfire is an amazing library. It has shown it's value in my pet project ([cookit.pl](http://cookit.pl)) and in a huge ERP system that we are building at work, where we replaced [Quartz.NET](http://www.quartz-scheduler.net/) with it and never looked back. 
<!--MORE-->

Why do I like it so much?

## 1. Scheduling
It enables:
- to fire(enqueue) and forget a job:

```csharp
	BackgroundJob.Enqueue(() => Console.WriteLine("Simple!"));`
```

- to schedule a one time job using a cron expression

```csharp
	BackgroundJob.Schedule(() => Console.WriteLine("Reliable!"), TimeSpan.FromDays(7));
```

- and to schedule a recurring job also with a cron expression

```csharp
	RecurringJob.AddOrUpdate(() => Console.WriteLine("Transparent!"), Cron.Daily)
```

>A side note: Cron expressions allow to express almost any time span, and using them is a standard in most task scheduling cases ([Quartz.NET](http://www.quartz-scheduler.net/), Unix, [TeamCity](https://www.jetbrains.com/teamcity/) to name a few). There is a good [Wikipedia page explaining the syntax](https://en.wikipedia.org/wiki/Cron#CRON_expression). Think of them as regular expressions for time.

I personally fell in love with the simplicity of this API, and especially with the fact that it takes a function to execute, not an object. Although this examples are simple lambdas Hangfire allows to schedule executing methods on almost any objects, but this is a topic for another post. Probably the next one:)
	

## 2. Persistence
The key point in procrastinating tasks is to not do them now, but to have certainty that they will be executed. That is why persisting jobs in a database is a key feature. And Hangfire has a hand of stores to persist in:
- SQL Server ([nuget package](Install-Package Hangfire.SqlServer))
- PostgreSql ([nuget package](postgres)) 
- Redis (nuget package, but only in paid pro version) 

And configuring any of them is as simple as scheduling a job:

```csharp
JobStorage.Current = new SqlServerStorage("HangfireConnectionString")
```

## 3. Job execution
Persisting a job in a database gives the possibility for another process to execute it. And Hangfire does just that. Of course the process executing the job has to have all the assemblies needed to execute the code, but this is just another argument for not having everything jammed into one project. Hangfire can be hosted by a:
- console application
- Windows service
- IIS website 

And configuring it is as easy as scheduling a job:
```csharp
GlobalConfiguration.Configuration.UseSqlServerStorage("HangfireConnectionString");
using (var server = new BackgroundJobServer())
{
    Console.WriteLine("Hangfire Server started. Press any key to exit...");
    Console.ReadKey();
}
```

## 4. Monitoring
For me the ability to have a graphic interface to see current jobs, queues, errors and processing servers was a must-have when choosing a library for a simple reason - I needed it and didn't want to write it myself. And Hangfire has just that:
![](/data/LocalOptimizationsDontAddUp/HangfireDashboard.png)

The dashboard is fully served be Hangfire (there is no need to add any CSS or JavaScript files) and configuring it is a one liner extension on OWIN IAppBuilder:

```csharp
	app.UseHangfireDashboard();
``` 

This was a glimpse of what this library can do. It's not always bells and whistles, but I've never regretted choosing it can't imagine working without the ability to schedule tasks. 
In the next post - a better look into jobs.