---
layout: post
title: Don't do it now! Part 3. Hangfire details - jobs
description: ""
modified: 2016-08-17
tags: [.NET, Hangfire, architecture, job scheduling]
image:
  feature: data/2016-08-17-Don't do it now! Part 3. Hangfire details - jobs/logo.jpg
---

This is the third part of a series discussing job scheduling and Hangfire details:

- [part 1 - Why schedule and procrastinate jobs?](/Don't-do-it)
- [part 2 - Overview of Hangfie](/Don't-do-it-now!-Part-2.-Background-tasks,-job-queuing-and-scheduling-with-Hangfire/)
- [part 3 - Scheduling and Queuing jobs in Hangfire](/Don't-do-it-now!-Part-3.-Hangfire-details-jobs/)

This part will focus on the basic scheduling API of Hangfire.
The easiest way to create a fire and forget job is by using the class`Hangfire.BackgroundJob` and it's minimalistic  (and this is a complement) API of static functions:

## Enqueue
As the name suggests it is **the** method for enqueuing jobs. It comes in different overrides:

```csharp
static string Enqueue(Expression<Func<Task>> methodCall);
static string Enqueue(Expression<Action> methodCall);
static string Enqueue<T>(Expression<Func<T, Task>> methodCall);
static string Enqueue<T>(Expression<Action<T>> methodCall);
```
Two of them are non generic implementations of the generic version, so it comes down to weather we want to:

- schedule an async function `Func<T, Task>`
- schedule a synchronius function `Action<T>`

What will be important further on is that all this methods return a string which a unique identifier of the job. It will come in handy in the next posts.

## Schedule
As the name suggests - it allows to enqueue a job, but delay it's execution by some time period. The overrides are:

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

- generic or non generic version
- async vs. sync (`Func<T, Task>` vs. `Action<T>`)
- delay it by a period from now, or execute it at specific time in future (`TimeSpan delay` vs. `DateTimeOffset`)

Similar to the `Enqueue`, this functions also return a string identifier of a job.

This two function is enough to start to worry about corner cases when using `SqlServerStorage` (probably the most common usage). These are some that needed to be checked and findings.

## Corner cases

### Does Hangfire using SQLServer storage requires an opened transaction?
No Hangfire will create it's own transaction scope and manage it. Code handling it an be found in [`Hangfire.SqlServer.SqlServerStorage.CreateTransaction`](https://github.com/HangfireIO/Hangfire/blob/master/src/Hangfire.SqlServer/SqlServerStorage.cs).

### If there is an opened transaction will Hangfire use it?
Yes Hangfire will enlist to an opened transaction, and use it. This means that the job will be enqueued only if rest of the process succeded and we commit the transaction.

### Does Hangfie using SQLServer storage support [distributed transactions](https://en.wikipedia.org/wiki/Distributed_transaction)?
Yes. Again the code can be found in [`Hangfire.SqlServer.SqlServerStorage.CreateTransaction`](https://github.com/HangfireIO/Hangfire/blob/master/src/Hangfire.SqlServer/SqlServerStorage.cs).

### Can I rely on object state?
No. Only things being serialized are:
- object type
- called method
- passed parameters
This means that we can't rely on any object state that the object had at the time of scheduling it's function, because it won't be recreated. This is why I wrote that Hangfire enables to schedule functions, and because in C# functions aren't [first class ciitizen](https://en.wikipedia.org/wiki/First-class_citizen) you have to keep this in mind. So a simple "Hello world" function will look like this:

```json
{  
   "Type":"System.Console, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089",
   "Method":"WriteLine",
   "ParameterTypes":"[\"System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089\"]",
   "Arguments":"[\"\\\"Hello, world!\\\"\"]"
}
```
Based on this info Hangfire will recreate the object and execue the function. This also brings us to a small performance tip to keep in mind: 
**keep Your parameters small, and be sure to know how they will be serialized** 

In the next post I will cover another funcion from this class - `ContinueWith`.