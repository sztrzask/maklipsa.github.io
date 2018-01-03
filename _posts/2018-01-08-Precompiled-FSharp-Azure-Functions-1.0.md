---
layout: post
title: Troubleshooting Azure Functions compiled functions and F#  
description: "When trying to run F# code as a precompiled Azure function strange thing happen. This is how to solve those problems."
modified: 2018-02-01
series: "Azure Functions"
tags: [azure, azure functions, F#, troubleshooting, .NET, F# type providers, compilation]
image:
  feature: data/2018-01-08-Precompiled-FSharp-Azure-Functions-1.0/logo.png
---


As I wrote in the [previous post](https://indexoutofrange.com/The-missing-Azure-Functions-documentation/) there are two ways to run precompiled .NET code in Azure Functions - .NET 4.6.x or .NET Core. So why I'm not running on .NET Core? For the current moment, F# on .NET Core does not support type providers (there is [a workaround](https://github.com/Microsoft/visualfsharp/issues/3303), but I didn't want to go with it for the current moment).
But running precompiled F# code is not that easy. Here is how to do it and why this way.

<!--MORE-->

## The problem

The easiest way to run precompiled functions in s to attach the F# repository to Azure Functions. This can be done  
from `Platform features->Deployment options->Setup`

![](/data/2018-01-08-Precompiled-FSharp-Azure-Functions-1.0/deployment-options.png)


Doing this will trigger code compilation and failure:

![](/data/2018-01-08-Precompiled-FSharp-Azure-Functions-1.0/deployment-failure.png)

## Build failure investigations

Clicking on the info shows the details:

![](/data/2018-01-08-Precompiled-FSharp-Azure-Functions-1.0/deployment-details.png)

Going deeper shows the log:

```batch
Command: "D:\home\site\deployments\tools\deploy.cmd"
Handling function App deployment with MSBuild.
Using Msbuild from 'D:\Program Files (x86)\MSBuild-15.3.409.57025\MSBuild\15.0\Bin'.
Nothing to do. None of the projects in this solution specify any packages for NuGet to restore.
Microsoft (R) Build Engine version 15.3.409.57025 for .NET Framework
Copyright (C) Microsoft Corporation. All rights reserved.

Build started 1/1/2018 11:08:14 AM.
Project "D:\home\site\repository\fsharptest.fsproj" on node 1 (default targets).
D:\Program Files (x86)\MSBuild-15.3.409.57025\MSBuild\Microsoft\VisualStudio\v15.0\FSharp\Microsoft.FSharp.NetSdk.props(3,3): error MSB4019: The imported project "D:\Program Files (x86)\Microsoft SDKs\F#\4.1\Framework\v4.0\Microsoft.FSharp.NetSdk.props" was not found. Confirm that the path in the <Import> declaration is correct, and that the file exists on disk. [D:\home\site\repository\fsharptest.fsproj]
Done Building Project "D:\home\site\repository\fsharptest.fsproj" (default targets) -- FAILED.

Build FAILED.

"D:\home\site\repository\fsharptest.fsproj" (default target) (1) ->
  D:\Program Files (x86)\MSBuild-15.3.409.57025\MSBuild\Microsoft\VisualStudio\v15.0\FSharp\Microsoft.FSharp.NetSdk.props(3,3): error MSB4019: The imported project "D:\Program Files (x86)\Microsoft SDKs\F#\4.1\Framework\v4.0\Microsoft.FSharp.NetSdk.props" was not found. Confirm that the path in the <Import> declaration is correct, and that the file exists on disk. [D:\home\site\repository\fsharptest.fsproj]

    0 Warning(s)
    1 Error(s)

Time Elapsed 00:00:00.90
Failed exitCode=1, command="D:\Program Files (x86)\MSBuild-15.3.409.57025\MSBuild\15.0\Bin\MSBuild.exe" "D:\home\site\repository\fsharptest.fsproj" /p:DeployOnBuild=true /p:configuration=Release /p:publishurl="D:\local\Temp\8d55107eb70a8ff"
An error has occurred during web site deployment.
\r\nD:\Program Files (x86)\SiteExtensions\Kudu\69.61204.3166\bin\Scripts\starter.cmd "D:\home\site\deployments\tools\deploy.cmd"
```

The key line is this one:

```batch
D:\Program Files (x86)\MSBuild-15.3.409.57025\MSBuild\Microsoft\VisualStudio\v15.0\FSharp\Microsoft.FSharp.NetSdk.props(3,3): 
error MSB4019: 
The imported project "D:\Program Files (x86)\Microsoft SDKs\F#\4.1\Framework\v4.0\Microsoft.FSharp.NetSdk.props" was not found. 
Confirm that the path in the <Import> declaration is correct, and that the file exists on disk. [D:\home\site\repository\fsharptest.fsproj]
```

It is a standard MSBuild output indicating that a `.props` (the same as `.target`. [MSBuild doesn't care about the extension](https://blogs.msdn.microsoft.com/msbuild/2010/02/25/getting-started-with-msbuild/)) file is missing.

Let's investigate.

## Azure Functions Advanced tools (Kudu)

Azure functions offer a limited, way to look into the underlying machine that is serving our functions - **Kudu**. It can be accessed in two ways:

- using a link `https://FUNCTION_APP_NAME.scm.azurewebsites.net/`
- by clicking on the portal `Platform features->DEVELOPMENT TOOLS->Advanced tools (Kudu)`

Kudu offers a lot of advanced functionalities (more than I have time to write in this blog post) but today we are interested in accessing the file system. This can be done by clicking the `Debug console->CMD/Powershell`:

![](/data/2018-01-08-Precompiled-FSharp-Azure-Functions-1.0/kudu-file-system.png)



This rings us to the file system, and cmd, explorer:

![](/data/2018-01-08-Precompiled-FSharp-Azure-Functions-1.0/kudu-file-system-explorer.png)
    
According to the error message we are interested in two paths:

- MSBuild props: `D:\Program Files (x86)\MSBuild-15.3.409.57025\MSBuild\Microsoft\VisualStudio\v15.0\FSharp\Microsoft.FSharp.NetSdk.props`
- FSharp props: `D:\Program Files (x86)\Microsoft SDKs\F#\4.1\Framework\v4.0\Microsoft.FSharp.NetSdk.props`

To explore the file system we can use normal cmd commands, or just click using the graphic representation (don't use the back button!). 

> Kudu file explorer has some glitches:
> - for reasons unknown to me the only way to go upper than default `d:\home` is to use the cmd `cd ..` command
> - entering the exact path to the folder using cd like: `cd D:\Program Files (x86)\MSBuild-15.3.409.57025\MSBuild\Microsoft\VisualStudio\v15.0\FSharp` does work in cmd, but the graphic file representation doesn't refresh
> - hiting Tab auto-completes the file/folder name (like in normal cmd), but only for the current level files/folders.

After navigating to the first file, its content can be viewed using the pen icon on the left. And it looks like this:

```xml
<Project xmlns="http://schemas.microsoft.com/developer/msbuild/2003">

  <Import Project="$(MSBuildProgramFiles32)\Microsoft SDKs\F#\4.1\Framework\v4.0\Microsoft.FSharp.NetSdk.targets" />

</Project>
```

So indeed `D:\Program Files (x86)\Microsoft SDKs\F#\4.1\Framework\v4.0\Microsoft.FSharp.NetSdk.props` is the file we are looking for.

### Locating the problem
 
Trying to locate the file will end on the `D:\Program Files (x86)\Microsoft SDKs\F#\` part of the file since it looks like this:

![](/data/2018-01-08-Precompiled-FSharp-Azure-Functions-1.0/kudu-file-explorer-fsharp.png)

See what is missing?

The first prop file (`Microsoft.FSharp.NetSdk.props`) points at this point into `4.1` folder and there is none.

The worst part is that in those folders we can't upload/change any files so from my perspective having auto-compiled F# functions is not going to work. 
So how to solve this issue? For me the only sensible way to go is to use Web Deploy and deploy to Azure Functions like to any other IIS site (what it actually is) - more on this in the next post. 
  
<style>
.entry-content img

{
    margin: 0 auto;
    display: block;
}
</style>
  