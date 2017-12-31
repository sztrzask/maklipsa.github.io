---
layout: post
title: The missing Azure Functions documentation  
description: "Azure Functions documentation is a mess. Trainings and blogsposts also. The main reason to it is that there is no single Azure Functions offering. There are three."
modified: 2018-01-01
series: "Azure Functions"
tags: [azure, azure functons, F#, .NET, compilation]
image:
  feature: data/2018-01-01-The-missing-Azure-Functions-documentation/logo.jpg
---

Trying to understand how to run code in Azure Functions is not a easy task since this product has evolved on its own and thanks to the rise of .NET Core. This post will try to give You a history background necessary to understand the the documentation and and all the blogsposts talking about Azure Functions.  

<!--MORE-->

### v1.0 - script files 

The initial way to run code in Azure Function was to write a script file in Azure Functions portal editor. Yes, You read correctly - **in the portal editor**. Later on deployment support was added, so we could deploy the `fsx` and `csx`. 
It works good, but has some drawbacks:

- compilation was done when the function was called for the first time (or was called after a long inactivity when Azure decided to kill the process)
- intellisence support is quite clumsy
- there is no compilation. Even when working on the code locally compiling the project did nothing since script files are not taken into account when compiling. This meant that we are loosing a lot of the benefits of a compiled language.  

### v1.1 - compiled functions

Microsoft addressed most problems script files have with the introduction of the ability to deploy to Azure Functions like just to any other IIS application - using Web Deploy (the same that we are using for ASP.NET and ASP.NET MVC when clicking Publish).

This can be done in two ways:

- **by deploying code**. This will trigger compilation on the Azure Functions machine, deploy the code to wwwroot folder and run discovery looking for functions declaration.
- **by deploying compiled code**. Storing compiled binaries in the repository is not a good idea so the best way to do it is to use Web Deploy mentioned earlier (btw. VSTS has a very good task for it)

Those two ways may look very similar, but deploying just the source code has some drawbacks:

- compilation is limited to .NET 4.6.1 (this is the version installed on the Azure Functions machines)
- we can use custom tools (Paket/Fake), but they have to be uploaded manually to `tools` folder.
- if we want to change the build process we have to manually change the `.deployment` and `deploy.cmd` files and this means that we (not Microsoft) are now supporters of those files. There is no point in looking for documentation for them (although they are quite easy build scripts).

### v2.0 - Azure Functions v2.0 
  
Azure Functions 2.0 (in beta by the time of writing) is Azure Functions running on Linux (the OS can be selected when creating the Funtion App):
![](/data/2018-01-01-The-missing-Azure-Functions-documentation/AzureFunctions2.png)

There are some changes/limitations compared to version 1.0:

- the OS is Linux
- runtime is .NET Core
- only C#, F#, JavaScript and Java is supported (Azure functions 1.0 supported Batch, C#, F#, JavaScript, PowerShell, Bash, Python and TypeScript)
- there is no consumption plan billing (as of time of writing, but I'm sure that one will be offered they go to stable)

Of course there are some benefits:

- .NET  Core is faster and consumes less memory. This is a significant benefit since in Azure Functions we are paying for execution time and used memory
- I suspect Linux offering will be a bit cheaper (VM with Linix tend to be cheaper)

## Summary

Azure Functions is evolving fast so make sure to look at the date when project/documentation/blogspost was recently updated.          
  