---
layout: post
title: Don't do it now! Part 3. Hangfire details - jobs
description: "A more deeper dive into Hangfire scheduling API"
modified: 2016-08-17
tags: [.NET, Hangfire, architecture, job scheduling]
image:
  feature: data/2016-08-17-Don't-do-it-now!Part-3.Hangfire-details-jobs/logo.jpg
---

This is the third part of a series discussing job scheduling and Hangfire details:

- [part 1 - Why schedule and procrastinate jobs?](/Don't-do-it)
- [part 2 - Overview of Hangfie](/Don't-do-it-now!-Part-2.-Background-tasks,-job-queuing-and-scheduling-with-Hangfire/)
- [part 3 - Scheduling and Queuing jobs in Hangfire](/Don't-do-it-now!-Part-3.-Hangfire-details-jobs/)
- [part 4 - Dashboard, retries and job cancellation](/Don't-do-it-now!-Part-4.-Hangfire-details-dashboard,-retries-and-job-cancellation/)
- [part 5 - Job continuation with ContinueWith](/Don't-do-it-now!-Part-5.-Hangfire-job-continuation,-ContinueWith/)
- [part 6 - Recurring jobs and cron expressions](/Don't-do-it-now!-Part-6.-Hangfire-recurring-jobs/)

This part will focus on the basic scheduling API of Hangfire.
The easiest way to create a fire and forget job is by using the class`Hangfire.BackgroundJob` and its minimalistic  (and this is a complement) API of static functions:
<!--MORE-->

## Enqueue
As the name suggests it is **the** method for enqueuing jobs. It comes in different overrides:

```csharp
static string Enqueue(Expression<Func<Task>> methodCall);
static string Enqueue(Expression<Action> methodCall);
static string Enqueue<T>(Expression<Func<T, Task>> methodCall);
static string Enqueue<T>(Expression<Action<T>> methodCall);
```
Two of them are non generic implementations of the generic version, so it comes down to whatever we want to:

- schedule an `async` function `Func<T, Task>`
- schedule a synchronous function `Action<T>`

What will be important further on is that all this methods return a string which is a unique identifier of the job. It will come in handy in the next posts.

## Schedule
As the name suggests - it allows to enqueue a job, but delay its execution by some time period. The overrides are:

```csharp
static string Schedule(Expression<Func<Task>> methodCall, DateTimeOffset enqueueAt);
static string Schedule(Expression<Func<Task>> methodCall, TimeSpan delay);
static string Schedule(Expression<Action> methodCall, DateTimeOffset enqueueAt);
static string Schedule(Expression<Action> methodCall, TimeSpan delay);
static string Schedule<T>(Expression<Func<T, Task>> methodCall, DateTimeOffset enqueueAt);
static string Schedule<T>(Expression<Func<T, Task>> methodCall, TimeSpan delay);
static string Schedule<T>(Expression<Action<T>> methodCall, TimeSpan delay);
static string Schedule<T>(Expression<Action<T>> methodCall, DateTimeOffset enqueueAt);
```
A few overrides, but it boils down to:

- generic or nongeneric version
- asynchronous vs. synchronous (`Func<T, Task>` vs. `Action<T>`)
- delay it by a period from now, or execute it at specific time in future (`TimeSpan delay` vs. `DateTimeOffset`)

Similar to the `Enqueue` this functions also returns a string identifier of a job.

This two function are enough to start to worry about corner cases when using `SqlServerStorage` (probably the most common usage), so here we go:

## Corner cases

### Does Hangfire using SQLServer storage requires an opened transaction?
No Hangfire will create its own transaction scope and manage it. Code handling it an be found in [`Hangfire.SqlServer.SqlServerStorage.CreateTransaction`](https://github.com/HangfireIO/Hangfire/blob/master/src/Hangfire.SqlServer/SqlServerStorage.cs).

### If there is an opened transaction will Hangfire use it?
Yes Hangfire will enlist to an opened transaction, and use it. This means that the job will be enqueued only if rest of the process succeeded and we commit the transaction.

### Does Hangfie using SQLServer storage support [distributed transactions](https://en.wikipedia.org/wiki/Distributed_transaction)?
Yes. Again the code can be found in [`Hangfire.SqlServer.SqlServerStorage.CreateTransaction`](https://github.com/HangfireIO/Hangfire/blob/master/src/Hangfire.SqlServer/SqlServerStorage.cs).

### Can I rely on object state?
No. Only things being serialized are:

- object type
- called method
- passed parameters

This means that we can't rely on any state that the object had at the time of scheduling its function because it won't be recreated. This is why I wrote that Hangfire enables to schedule *functions*. Because in C# functions aren't [first class citizens](https://en.wikipedia.org/wiki/First-class_citizen), but they are tied to a object instance you have to be more careful. To give an example of how a "Hello world" job looks in storage:

```json
{  
   "Type":"System.Console, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089",
   "Method":"WriteLine",
   "ParameterTypes":"[\"System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089\"]",
   "Arguments":"[\"\\\"Hello, world!\\\"\"]"
}
```
Based on this info Hangfire will recreate the object and execute the function. This also brings us to a small performance tip to keep in mind: 
**keep your parameters small, and be sure to know how they will be serialized** 
