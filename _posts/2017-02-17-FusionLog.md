---
layout: post
title: Could not load file or assembly or one of its dependencies.
description: "Description how .NET loads assemblies"
modified: 2017-02-27
tags: [.NET, cookit, Fusion log, assembly]
image:
  feature: data/2017-02-19-FusionLog/logo.jpg
---

<link rel="stylesheet" href="/assets/css/tooltips_style.css">
In most cases .NET manages to solve the [DLL hell problem](https://en.wikipedia.org/wiki/DLL_Hell), but sometimes it all falls apart, and when it does in best case You will see this:

```console
Could not load file or assembly 'XXXX, Version=X.Y.Z.W, Culture=neutral, PublicKeyToken=eb42632606e9261f' or one of its dependencies. The located assembly's manifest definition does not match the assembly reference. (Exception from HRESULT: 0x80131040)
```

This is a description what to do then
<!--MORE-->

## Enable assembly binding logging (Fusion log)

Assembly binding is turned on using those registry settings:

- `HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Fusion\EnableLog` - Type of DWORD
- `HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Fusion\ForceLog` - Type DWORD
- `HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Fusion\LogFailures` - Type DWORD
- `HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Fusion\LogResourceBinds` - Type DWORD
- `HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Fusion\LogPath` - Type String

To enable logging the first four should be set to `1` and the last to a **existing** directory path (it should also end with an `\`)

It can be enabled manually, by with the use of `regedit.exe`, but since it can be automated here are the scripts:

[![Disable Fusion Log](/data/2017-02-19-FusionLog/reg.png){: .regIco}Disable Fusion Log](/data/2017-02-19-FusionLog/disable-full-fusion.reg)
[![Enable Fusion Log](/data/2017-02-19-FusionLog/reg.png){: .regIco}Enable Fusion Log](/data/2017-02-19-FusionLog/enable-full-fusion.reg)

> DON'T RUN THIS, OR ANY OTHER SCRIPT WITHOUT CHECKING IT'S CONTENT.
 
After this there are two ways to precede:

### With a tool 

Windows has a build-in tool called `Fuslogvw.exe`. It should be located in several places, but the pattern is: `C:\Program Files (x86)\Microsoft SDKs\Windows\<<SDK_VERSION>>\bin\NETFX <<RUNTIME_VERSION>> Tools\`.
Any version will do since the tool is available from [.NET version 1.1](https://msdn.microsoft.com/en-us/library/e74a18c4(v=vs.71).aspx), and the version numbers between 4.6.2 and 4.0 differ only in minor version.

### Looking at the files

This is my preffered way to diagnose since the files names are names using loaded assembly full name, plus `HTM` extension. For example:

`NLog, Version=4.0.0.0, Culture=neutral, PublicKeyToken=5120e14c03d0593c`

so we have:

`[assembly name], Version=[assembly version], Culture=[culture], PublicKeyToken=[public token]`

To better understand what is happening lets look at a file where the binding succeded, and explain the fragments.

Date and time of the load. It can be usefull to make sure that it the load we are looking for:

## Fusion Log file

<article class="post">
*** Assembly Binder Log Entry  (<a href="#" class="tooltip tooltip-right" data-tooltip="Date and time when the runtime attempted to locate the assembly.">25.02.2017 @ 13:44:54</a>) ***<br/>
<br/>
<a href="#" class="tooltip tooltip-right" data-tooltip="The result of this try." >The operation was successful.<br/>
Bind result: hr = 0x0. The operation completed successfully.</a><br/>
Assembly manager loaded from:  <a href="#" class="tooltip tooltip-right" data-tooltip="The exact runtime manager responsible for locating the assembly.">C:\Windows\Microsoft.NET\Framework\v4.0.30319\clr.dll</a><br/>
Running under executable  <a href="#" class="tooltip tooltip-right" data-tooltip="The executable that initialized the process.">d:\src\FusionLogTest\FusionLogRunner\bin\Debug\FusionLogRunner.exe</a><br/>
<br/>
--- A detailed error log follows.<br/>
=== Pre-bind state information ===<br/>
LOG: <a href="#" class="tooltip tooltip-right" data-tooltip="Exact assembly that is being looked for.">DisplayName = NLog, Version=3.2.1.0, Culture=neutral, PublicKeyToken=5120e14c03d0593c</a>
(Fully-specified)<br/>
LOG: <a href="#" class="tooltip tooltip-right" data-tooltip="Folder of the executable that initialized the process.">Appbase = file:///d:/src/private/FusionLog/FusionLogRunner/bin/Debug/</a><br/>
LOG: Initial PrivatePath = NULL<br/>
LOG: Dynamic Base = NULL<br/>
LOG: Cache Base = NULL<br/>
LOG: <a href="#" class="tooltip tooltip-right" data-tooltip="Name of the executable that initialized the process.">AppName = FusionLogRunner.exe</a><br/>
<a href="#" class="tooltip tooltip-right" data-tooltip="The assembly that has the refference to assembly that the runtime is trying to load.">Calling assembly : FusionLogLib, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null.</a><br/>
===
LOG: This bind starts in default load context.<br/>
LOG: <a href="#" class="tooltip tooltip-right" data-tooltip="Configuration file for the executable that initialized the process.">Using application configuration file: d:\src\private\FusionLog\FusionLogRunner\bin\Debug\FusionLogRunner.exe.Config</a><br/>
LOG: Using host configuration file: <br/>
LOG: Using machine configuration file from C:\Windows\Microsoft.NET\Framework\v4.0.30319\config\machine.config.<br/>
LOG: <a href="#" class="tooltip tooltip-right" data-tooltip="The runtime found a redirect for this assembly to version 4.0.0.0">Redirect found in application configuration file: 3.2.1.0 redirected to 4.0.0.0.</a><br/>
LOG: Post-policy reference: NLog, Version=4.0.0.0, Culture=neutral, PublicKeyToken=5120e14c03d0593c<br/>
LOG: <a href="#" class="tooltip tooltip-right" data-tooltip="Info that it managed to locate the redidected assembly, and the location of that assembly.">Binding succeeds. Returns assembly from d:\src\private\FusionLog\FusionLogRunner\bin\Debug\NLog.dll.</a><br/>
<br/>
LOG: Assembly is loaded in default load context.<br/>
</li>
		<!-- 8--><li></li>
		<!-- 9--><li>
		<!-- 10--><li></li>
		<!-- 11--><li></li>
	</ol>
</article>

This file contains a heep of info:

- what manager was used to load the assembly
- exact version of the assembly that was being searched
- location of the calling application
- name of the calling application
- `Calling assembly`. This is the assembly that needed this dependency. In this case the chain was: 
- 



## Trouble shooting 

### I don't see the logs from my application

The application **has to be restarted** after enabling the log. When talking about IIS application the whole IIS process has to be restarted.

### I don't see the folder

You have to create the folder manually

### The application runs slower

The logging ads some overhead, but not enough for it to be seen with a bare eye. Maybe You are doing a lot of dynamic assembly loading? 
 
### Something is eating up my disc space

Disable the log. When enabled it creates a lot of small files. The result is that they are taking up more disc space than they actual size.  

### The logs are still being created despite disabling the logging

Restart the application process.



<style>
.regIco{
    height:150px;
}
p, ol, ul {
  margin: 0 0 0 0;
}

.post {
  
  &.has-sidenotes {
    width: percentage(4/5);
    
    p:not(.sidenote) {
      position: relative; 
    }
  }
}
.post p { position:relative; }

p.sidenote {
  width: 50%;
  line-height: (24/14); /*to achive the same line height as the paragraph text*/
  font-style: italic;
  position: absolute;
  top: 0;
  left: 100%;
}

.footnotes {
  padding-top: 1.5rem;
  border-top: 1px solid #cccccc;  
  font-size: 0.85em;
}

[data-note]::after {
  position: relative;
  top: -0.5em;
  
  font-size: 0.75em;
  
  content: "\202f[" attr(data-note) "]"; // a very thin non-breaking space
  
  .has-sidenotes & {
   display: none; 
  }
}
</style>

<script src="//ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
<script type="text/javascript" >
var $window = $(window),    $document = $(document),$html = $('html'),$post = $('.post'),$footnotes = $('.footnotes'),noteTextArray = [];

function formatNotes() {
  var em = parseInt($html.css('font-size'));
  setupSidenotes();
}

function setupSidenotes() {
  $post.addClass('has-sidenotes');
  $footnotes.hide();
  
  $('.sidenote').remove();
  for (var i = 0; i < noteTextArray.length; i++) {
    $('[data-note=' + (i + 1) +']').parent().append("<p class='sidenote'>" + noteTextArray[i] + "</p>");
  }
}

$document.ready(function() {
  var $footnoteArray = $('.footnotes').children();
  
  for (var i = 0; i < $footnoteArray.length; i++) {
    noteTextArray.push($($footnoteArray[i]).html()); 
  }
  
  formatNotes();
});

$window.resize(function() {
  formatNotes();
});
</script>