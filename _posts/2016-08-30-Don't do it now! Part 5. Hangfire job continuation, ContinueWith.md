---
layout: post
title: Don't do it now! Part 5. Hangfire details - job continuation with ContinueWith
description: "A look how Hangfire enables to chain jobs with ContinueWith"
modified: 2016-08-30
tags: [.NET, Hangfire, architecture]
image:
  feature: data/2016-08-30-Don't-do-it-now!Part-5.Hangfire-job-continuation,-ContinueWith/logo.jpg
---

This is a fifth part of a series:

- [part 1 - Why schedule and procrastinate jobs?](/Don't-do-it)
- [part 2 - Overview of Hangfie](/Don't-do-it-now!-Part-2.-Background-tasks,-job-queuing-and-scheduling-with-Hangfire/)
- [part 3 - Scheduling and Queuing jobs in Hangfire](/Don't-do-it-now!-Part-3.-Hangfire-details-jobs/)
- [part 4 - Dashboard, retries and job cancellation](/Don't-do-it-now!-Part-4.-Hangfire-details-dashboard,-retries-and-job-cancellation/)
- [part 5 - Job continuation with ContinueWith](/Don't-do-it-now!-Part-5.-Hangfire-job-continuation,-ContinueWith/)
- [part 6 - Recurring jobs and cron expressions](/Don't-do-it-now!-Part-6.-Hangfire-recurring-jobs/)

[Part 3](/Don't-do-it-now!-Part-3.-Hangfire-details-jobs/) covered almost all functions in `BackgroundJob` class except for `ContinueWith` functions family. So here we go :)

The fact that it has the same name as a `System.Threading.Tasks.Task` function is not without a coincidence, or at least I hope so. This method allows chaining jobs where one will be enqueued when the previous finishes. To repeat - the job won't be executed, but enqueued. So it will go at the end of the queue.
So lets look at the function and overrides signature:

```csharp
static string ContinueWith(string parentId, Expression<Action> methodCall);
static string ContinueWith(string parentId, Expression<Action> methodCall, JobContinuationOptions options);
static string ContinueWith(string parentId, Expression<Func<Task>> methodCall, JobContinuationOptions options = JobContinuationOptions.OnlyOnSucceededState);    
static string ContinueWith<T>(string parentId, Expression<Action<T>> methodCall);
static string ContinueWith<T>(string parentId, Expression<Action<T>> methodCall, JobContinuationOptions options);
static string ContinueWith<T>(string parentId, Expression<Func<T, Task>> methodCall, JobContinuationOptions options = JobContinuationOptions.OnlyOnSucceededState);
```

The API enables to fire multiple methods when one finishes, but not doing the opposite. This scenario was recently covered by [Batches](http://docs.hangfire.io/en/latest/background-methods/using-batches.html), but it is a topic for a separate post, and they are available only in the paid version. So let's have a look at the function and their overrides:

So let's look at what differentiates the overrides:

- generic vs. nongeneric
- synchronous vs. asynchronous. This time, they are not exactly equal because methods differ in the fact that there are two versions for the synchronous override. One with `JobContinuationOptions` and one without. The asynchronous only has one with default initialization. This was probably done to keep backward compatibility (reflection, assembly binding), and since `async` support was implemented after `ContinueWith`. 

We looked at the differences, let's look at the similarities:

- `parentId` - remember the unique job id returned by all the functions from [enqueue part of the API](/Don't-do-it-now!-Part-3.-Hangfire-details-jobs/)? This is one of the cases when it comes in handy.
- `JobContinuationOptions` - this is an `enum` and has two options:
    - `OnAnyFinishedState` - the default one, meaning the job will execute regardless of whatever parent finishes with success, or throws an error. 
    - `OnlyOnSucceededState` - the job will fire only when parent succeeded (didn't throw any exception, or didn't timeout)
- the return value is of curse a unique job id, so we can chain many jobs.

Continuation can introduce some edge cases, here are those came into my mind:
### Will continuations be executed once more if we enqueue the parent job that ended successfully?
The short answer is no. Continuation jobs will be enqueued only if they are in `AwaitingState` (special state for continuation jobs in Hangfire state machine).

### What happens to continuations scheduled to execute on success when the parent fails and after retry succeeded?
To put it simply: is it possible for the parent job to finish and not enqueue continuations?
No. They are done in one transaction. 

### What if we continue on a job that already executed?
Continuations will be enqueued immediately.

### Why should I use ContinueWith if I can enqueue continuation job at the end of parent job?
To keep the code clean. Hangfire is just a way to execute functions, and in most cases, there is no need for it know, is it running from Hangfire or from a web request. It is just a matter of keeping code clean. 

### Can a parent job pass parameters to continuations?
No. If that's the case I would recommend [TPL Dataflow](https://msdn.microsoft.com/en-us/library/hh228603(v=vs.110).aspx) or some agent system like [Akka.NET](http://getakka.net/) or [Orleans](https://github.com/dotnet/orleans). Another option is to enqueue the child job at the end of parent job, but this can get messy. 