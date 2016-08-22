---
layout: post
title: Don't do it now! Part 4. Hangfire details - dashboard, retries and job cancellation 
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
![dashboard Main](/data/2016-08-22-Don't-do-it-now!-Part-4.Hangfire-details-dashboard,retries-and-job-cancellation/dashboard_main.png)
This is the main view of what the server is doing, and how well (are the jobs failing)
The more interesting part is the next view:
![dashboard Main](/data/2016-08-22-Don't-do-it-now!-Part-4.Hangfire-details-dashboard,retries-and-job-cancellation/dashboard_jobs.png)
There's a bit more detail about jobs in all states. They are self exploratory, maybe except the awaiting, but I will cover this in the next post.
We can go as deep as to see the state of the specific job, which will look like this:
![dashboard Main](/data/2016-08-22-Don't-do-it-now!-Part-4.Hangfire-details-dashboard,retries-and-job-cancellation/dashboard_failedJob.png)

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

This question becomes even more interesting when:

- we look at [IJobCancellationToken in the documentation](http://docs.hangfire.io/en/latest/background-methods/using-cancellation-tokens.html), so there is some kind of cancellation supported.
- see that Hangfire is using [`System.Threading.CancellationToken`](https://msdn.microsoft.com/en-us/library/system.threading.cancellationtoken%28v=vs.110%29.aspx?f=255&MSPPError=-2147217396)
- we take into account that `Delate` may be called from a **different machine** then currently executing the job

Cancellation can be triggered by two events, and both of the handle it differently:

- **server shutdown.** A bit simplified tale of what is happening:

	When `BackgroundJobServer`([github](https://github.com/HangfireIO/Hangfire/blob/master/src/Hangfire.Core/Server/BackgroundProcessingServer.cs)), which is responsible for job execution, is being shutdown it stops processing new messages and triggers [`Cancel`](https://msdn.microsoft.com/en-us/library/dd321955(v=vs.110).aspx) on its [`CancellationTokenSource`](https://msdn.microsoft.com/en-us/library/system.threading.cancellationtokensource%28v=vs.110%29.aspx?f=255&MSPPError=-2147217396). This token is used by `Worker`([github](https://github.com/HangfireIO/Hangfire/blob/master/src/Hangfire.Core/Server/Worker.cs)) class to create the `ServerJobCancellationToken` ([github](https://github.com/HangfireIO/Hangfire/blob/master/src/Hangfire.Core/ServerJobCancellationToken.cs)) instance that will be injected into the method if it has a parameter of type `IJobCancellationToken`. Calling `ThrowIfCancellationRequested`, checks the token and throws a special Hangfire meaning that the method finished due to issued cancellation. This way the server can gently close currently processing jobs.

- **job delete.** This process is a bit simpler.
	
	`Delete` method uses the `IBackgroundJobStateChanger` ([github](https://github.com/HangfireIO/Hangfire/blob/master/src/Hangfire.Core/States/IBackgroundJobStateChanger.cs)), implemented by `BackgroundJobStateChanger`([github](https://github.com/HangfireIO/Hangfire/blob/master/src/Hangfire.Core/States/BackgroundJobStateChanger.cs)), to change the state of the job to `Deleted` and write it to storage.
	
	If we look at the implementation of `ThrowIfCancellationRequested` in `ServerJobCancellationToken`([github](https://github.com/HangfireIO/Hangfire/blob/master/src/Hangfire.Core/ServerJobCancellationToken.cs)) we see that it checks the token and also if job state didn't change to 'Deleted'. If it did a `JobAbortedException`([github](https://github.com/HangfireIO/Hangfire/blob/master/src/Hangfire.Core/Server/JobAbortedException.cs)) will be thrown. This type of exception is recognised by the processing pipeline as a response to issued cancellation. 

In my opinion this is quite a nice implementation without any potencial to be a leeke abstraction.