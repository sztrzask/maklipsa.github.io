---
layout: post
title: Debugging high memory usage. Part 1 - ProcDump 
description: "Analysis of high memory usage can be tricky. This post describes the first steps needed in most cases - how to create a memory dump of the process."
modified: 2016-09-19
tags: [.NET, memory dump, SysInternal Siute, ProcDump]
series: "Debugging high memory usage"
image:
  feature: data/2016-09-21-Debugging-high-memory-usage.Part-1-ProcDump/logo.png
---

I'm taking a short break from [Hangfire series](/Don't-do-it/), but I will get back to it.

This time - Where did my memory go ? Or to be more exact: Why is this using so much memory?

The story starts with one IIS application pool using around 6 Gigabytes of memory on one of our test environments. It was several times above the values that we expected it to use, so we decided to investigate.

Without much thinking we fired up Visual Studio installed on the test server, and attached to the process. Since the application was build in Debug mode we had all the pdb files in the website folder. 

Do I have your attention now? The above paragraph is of curse a joke and a bunch of **anti patterns. Don't do any of them!**

<!--MORE-->
Now that I have your attentions let's get back to what really happened. Since it was a remote sever handling multiple enviroments the only sane step to take is to make a memory dump of the process, kill it and analyze it on a developers machine. Since we always have [Sysinternals Suite](https://technet.microsoft.com/en-us/sysinternals/bb842062.aspx?f=255&MSPPError=-2147217396) in `c:\tools` (highly recommend having it, because when You need it the most, there is no time for download). Sysinternals Suite contains a simple console application for making process dump called `procdump.exe`. 

> `ProcDump` is a very powerful tool and it's capabilities go far beyond what I will show now. To just give a glimpse flags that control then the dump will be triggered:
>
> - `c` and `cl`- create a dump when **CPU threshold** is above or below given limit
> - `e` -  create a dump when **unhandled exception is thrown**
> - `h` - create a dump when processes **window is not responsive**
> - `m` and `ml` -  create a dump when **CPU threshold** is above or below given limit
> - `p` and `pl` - create a dump when a given **performance counter** is above or below a given limit
> - `t` - create a dump when the **process terminates**
> - absence of this flags means trigger the dump now
> For a better insight of what ProcDump can do fire it up without any arguments and it will display a very good help.

In this case we wanted to get the dump right now, so the command line looked like this:

``` shell
procdump.exe 25944 c:\temp\ -ma
```  

To decompose:

- `25944` is the process id. We could pass a process name, but since it is a website hosted by IIS its process is named w3wp.exe.

> Process id (PID in short) can be obtained be many tools such as `ProcessExplorer` which is also a part of SysInternals Suite. But the default Task Manager available on any Windows machine also has it. 
> Just right click on the Name column, and check `PID` in the menu that will appear.

- `c:\temp` is the folder where the dump will be written to 
- `ma` flag says that we want a full dump with all of processes memory written to the file.

If you get this error:

``` shell
Error opening w3wp.exe (25944):
Error 0x00000005 (5): Access is denied.
```

That is because it has to be run with administrator privileges like any debugger. The normal output should look like this:

``` shell
ProcDump v8.0 - Writes process dump files
Copyright (C) 2009-2016 Mark Russinovich
Sysinternals - www.sysinternals.com
With contributions from Andrew Richards

[12:48:59] Dump 1 initiated: c:\temp\w3wp.exe_160917_124859.dmp
[12:49:03] Dump 1 writing: Estimated dump file size is 5612 MB.
[12:49:59] Dump 1 complete: 5614 MB written in 55.6 seconds
[12:50:00] Dump count reached.
```
  
So we have the dump. What next? This is the topic for the next post :)