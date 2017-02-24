---
layout: post
title: FusionLog
description: "Description how .NET loads assemblies"
modified: 2016-12-22
tags: [.NET, cookit, Fusion log, assembly]
image:
  feature: data/2017-02-19-FusionLog/logo.jpg
---

In most cases .NET manages to solve the [DLL hell problem](https://en.wikipedia.org/wiki/DLL_Hell), but sometimes it all falls apart, and when it does in best case You will see this:

```console
Could not load file or assembly 'XXXX, Version=X.Y.Z.W, Culture=neutral, PublicKeyToken=eb42632606e9261f' or one of its dependencies. The located assembly's manifest definition does not match the assembly reference. (Exception from HRESULT: 0x80131040)
```

In the worst You will get a runtime exception that a method was not found, and You feel like this:
<!--MORE-->

![](/data/2017-02-19-FusionLog/tourists.jpg)



 
