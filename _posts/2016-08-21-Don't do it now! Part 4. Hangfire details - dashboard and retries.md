---
layout: post
title: Don't do it now! Part 4. Hangfire details - retries
description: ""
modified: 2016-08-17
tags: [.NET, Hangfire, architecture, job scheduling]
image:
  feature: 
---

This is the fourth part of a series discussing job scheduling and Hangfire details:

- [part 1 - Why schedule and procrastinate jobs?](/Don't-do-it)
- [part 2 - Overview of Hangfie](/Don't-do-it-now!-Part-2.-Background-tasks,-job-queuing-and-scheduling-with-Hangfire/)
- [part 3 - Scheduling and Queuing jobs in Hangfire](/Don't-do-it-now!-Part-3.-Hangfire-details-jobs/)
- [part 4 - Retries and dashboard](/Don't-do-it-now!-Part-3.-Hangfire-details-jobs/)

This part will cover few small topics:

- dashboard
- retries 
- more technical part of the `Hangfire.BackgroundJob` class API
- job cancellation

## Dashboard
Let's start with the administrative dashboard because it gives a good background for the rest of the post.
It greets us with more or less this view:
![dashboard Main](/data/2016-08-21-Don't do it now! Part 4. Hangfire details - dashboard and retries/dashboard_main.png)
This is the main view of what the server is doing, and how well (are the jobs failing)
The more interesting part is the next view:
![dashboard Main](/data/2016-08-21-Don't do it now! Part 4. Hangfire details - dashboard and retries/dashboard_jobs.png)
There's a bit more detail about jobs in all states. They are self exploratory, maybe except the awaiting, but I will cover this in the next post.
We can go as deep as to see the state of the specific job, which will look like this:
![dashboard Main](/data/2016-08-21-Don't do it now! Part 4. Hangfire details - dashboard and retries/dashboard_failedJob.png)

And this brings us to the main motives of this post:

- auto retries
- the ability to delete a job
- the ability to requeue a job

## Auto retry
This one is easy. Hangfire will auto retry every job that failed (timeouted, or thrown an exception) ten times. Each retry is like enqueuing it to the queue, so it goes at the end of the queue.

## Manual requeue
This can be done in several ways:

- on the job page
- on the jobs page (allows requeuing multiple jobs).
- manually using `Requeue` from `Hangfire.BackgroundJob` :

```csharp
    static bool Requeue(string jobId);
    static bool Requeue(string jobId,string fromState);
```
Remember the unique job id returned by schedule methods from [previous post](/Don't-do-it-now!-Part-3.-Hangfire-details-jobs/)? This is one place it becomes useful, but there will be next.
The one parameter one is simple, so no explanation needed. The second one has a additional parameter, `fromState` which is a fail switch. Job will be deleted only if it is in this state.

## Delete a job
A similar story as with requeuing. It can be done from the UI, or with the API:

```csharp
    static bool Delete(string jobId);
    static bool Delete(string jobId, string fromState);
```

No surprises here. The API is very similar as `Requeue`.
This would seem to end the topic of `Delete`, but one very important question should pop into Your mind:
> Just how does Hangfire delete a job? 

And to be more precise: 

> What does Hangfire mean by delete when talking about an executing job.

This question becomes even more valid when we look at [IJobCancellationToken in the documentation](http://docs.hangfire.io/en/latest/background-methods/using-cancellation-tokens.html) 