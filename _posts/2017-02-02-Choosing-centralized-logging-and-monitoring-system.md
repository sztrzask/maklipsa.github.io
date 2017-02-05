---
layout: post
title: Choosing centralized logging and monitoring system
description: "Searching through logs and remoting to a machine to check it's load is not a fun thing to do. This is why I've decided to look for a centralized logging service. And what I've chose."
modified: 2017-01-30
tags: [.NET, cookit, performance, similarity, bit operations, azure, application insights]
image:
  feature: data/2017-02-02-Choosing-centralized-logging-and-monitoring-system/logo_04.jpg
---

While I'm working on the next angle on [how to speed up calculating similarities]() I started investigating how to get better telemetry from [cookit](http://cookit.pl). Getting telemetry is easy - making sense of it is the hard part. This also brought another pain point of current setup - logging and monitoring.
Since cookit is my pet, non profit project it was time to do something.

<!--MORE-->

### The current state

The current setup is based on:

- **NLog** - used for almost all logging in the website and Windows Service. Most errors are logged into files, the critical ones are emailed to my account.
- **Hangfire dashboard** - for checking job status and if it ended with a failure, the main exception. 
- **Remote Desktop** - for trouble shooting, performance counters and all monitoring stuff (and I know how badly this sucks)


Except for the last one the setup was more or less OK on the daily basics. But in more advanced scenarios it started lacking more and more:

- email notifications are fine for being informed that something is wrong, but for the details I have to RDP and see the files and this is tolerable only on a PC. Doing this on a tablet or a phone is waisting time.
- no performance metrics except for Hangfire dashboard.
- since [I am running cookit on crappy hardware](/The-importance-of-running-on-crapp) RDP is slow. 
- any analytics or finding correlations had to be done manually, and this is a pain and a waste of my time.
- no way to do a post morten why the site was slow an hour ago. If something started throwing errors 

## Objectives

So what I wanted to achieve (in order of importance):

- **Visualizations.** Yes, this is the first place. Looking at tables is the worst way to get a glimpse of what is happening. A simple chart makes huge difference.
- **Accessible everywhere.** This means o need to RDP, or any app that has to be installed. It has to be web based.   
- **Not running on my machine.** Any system needs some taking care of it. Check the logs once in a time, upgrade to newer version and so on. This requiers time and knowledge (knowledge can be translated into time needed to have it), and for the current moment this is not the area where I want to invest my time. 
- **performance counters of the machine.** Knowing the stats of the application without knowing the stats of the whole machine is close to pointless when things go haywire. 
- **Centralized logging.** I will be sending data from a website and a Windows Service. It has to be in one place.
- **Custom events.** I want to add custom timings for each TPL Dataflow block that I am using for building data processing workflows.
- **Real time.** - when I get a report from [Pingdom](https://www.pingdom.com/) that the site is not responding I want to check what is happening right now on the machine. Hour old data in this case is no use.
- **Alerting** - Having monitoring without alerting works only when you can have a huge monitors only for showing the dashboard. Even then it only works in movies. Alerting is a must have and a time saver.
- **Historic data.** - The time between getting an alert and having time to look at it is almost always non zero. Having at least 8 hours (remember that sleep is a good thing?) of data is a must have. The time span may suggest it, but to be clear, it has to be written in a persistent way, because it so happens that restarts and performance problems co ocur. 

## What the market has to offer

![Google Analytics](/data/2017-02-02-Choosing-centralized-logging-and-monitoring-system/google-analytics_01.png){: .logo}

### Google Analytics

Google Analytics is way more than SEO/SEM tool. With the support of custom client and server events it can easily be turned into monitoring tool. 
Another plus for using it is that you probably have it already and are looking at it from time to time.

**The good**
- good/decent visualizations
- very good UI
- accessible everywhere
- fast
- free (under few millions of events daily)
- I already have it
- has custom events
- monitors browser performance
- supports custom client and server events 
- has custom dashboards
- good Android application

**The bad**
- working with custom events is not that great
- no collection of system performance counters (can be easily written, but still a minus)
- no log aggregation
- no alerting

![ELK Stack + Graphite/Graphana](/data/2017-02-02-Choosing-centralized-logging-and-monitoring-system/elk.png){: .logo}

### ELK Stack + Graphite/Graphana

ELK stack with Graphite and Graphana is the market standard for monitoring and central logging. This means that it is very easy to find Docker images, help and almost everything what is needed.
Viewing on mobile deices is possible, but far from being great, and this won't change any time soon judging from [this Github issue](https://github.com/elastic/kibana/issues/2563). 

**The good**

- the market standard
- great visualizations (both Graphite and Kibana)
- great data crunching tools
- there are some ELK as a service providers.
- great UI and visualization
- web based
- there are existing applications for server stats monitoring 

**The bad**

- mostly Linux based and since I am running on a Windows Server this meant getting another Linux machine. Setting every 
- most providers are not free
- a lot of stuff to manage on my own
- no out of the box monitoring



![New Relic](/data/2017-02-02-Choosing-centralized-logging-and-monitoring-system/newRelic.svg){: .logo}

New Relic is a power horse for monitoring and reporting. 

### New Relic

New Relic is a power horse when it goes for features. It has almost everything, from APM (Application Performance Metrics) to log aggregation. It is a very interesting product since it is done in a way that will be readable to non technical people. You automaticly get notifications for apdex index violations, and the UI is more like google analytics than Azure Application Insights (next)

The main dashboard:

![NewRelic panel](/data/2017-02-02-Choosing-centralized-logging-and-monitoring-system/newRelic_panel.png)

I was quite impressed with how good NewRelic inspects what went into each request. This is the Request monitoring page:
![NewRelic request details](/data/2017-02-02-Choosing-centralized-logging-and-monitoring-system/newRelic_requestDetails.png)

Another thing that is a nice feature is the Geo view. It shows how page speed differs for different geo locations. And as You can see I have a problem with Russia (have no idea why):

![NewRelic request details](/data/2017-02-02-Choosing-centralized-logging-and-monitoring-system/newRelic_geoPanel.png)  

All what is needed is installation of a NewRelic Agent on the server. Dependencies detection and metering works out of the box, and it is the easiest tool to setup. Even browser monitoring doesn't require any additional code.

**The good**

- out of the box monitoring of .NET,Ruby, Node.js, PHP, Java, Python and Go applications
- Supports web and non-web applications
- Supports browser monitoring
- fast and very good UI
- Browser profiling works without the need to add a script (it is added automaticly by the installed NewRelic agent)

**The bad**

- only paid version, and without all features enabled. Some are available only after contact from the sales department.
- every part is seperatly paid 
- at registration(demo) requiers phone number,company name, company size and role.

![Retrace](/data/2017-02-02-Choosing-centralized-logging-and-monitoring-system/retrace.png){: .logo}

### Retrace
**The good**

**The bad**

![Application Insights](/data/2017-02-02-Choosing-centralized-logging-and-monitoring-system/ApplicationInsights.png){: .logo}

### Application Insights

Microsoft is investing heavily in it's Azure cloud and it can be seen from number of features they are rolling out every three months. They are investing more in the PaaS model and Application Insights fits quite good in this enviroment.
Azure feels a lot more developer orientated platform than NewRelic. It can bee easily seen that they thought more about query capabilities (AND, OR operators) than in how to get the visualizations super nice.

My customized main dashboard:
![Azure dashboard](/data/2017-02-02-Choosing-centralized-logging-and-monitoring-system/azure_panel.png)

And the request details:
![Azure dashboard](/data/2017-02-02-Choosing-centralized-logging-and-monitoring-system/azure_requestDetails.png)
As you can see all dependencies were detected neetly.

There is also one thing that strongly shows that Application Insights is targeted at IT specialists. By clicking Analyze in the top bar we can see the query behind every diagram, change it and use it for a custom report. Language used is very similar to, or is, F# this means we have piping and support for data manipulation functions. As person using F# I must say "good move" :)
![Azure dashboard](/data/2017-02-02-Choosing-centralized-logging-and-monitoring-system/azure_querryEditor.png)

**The good**

- out of the box monitoring of sever and browser (needs adding Google Analytics like script)
- can be added without access to the code. This does not allow full capabilities (dependency tracking and pref monitoring is available), but most of them. 
- auto detected HTTP requests and ADO queries (SQL queries)
- 1 GB a month free
- has data limits
- has sampling
- very good search feature that searches in products and instances. This is more important than one might think because the number of screens is massive. Even only in the Application Insights module.  
- customizable dashboard for every Azure offering (every panel can be moved to the main dashboard)
- the top bar has connected features. Like when you open the pricing windows it contains a to the data limit window. 

**The bad**

- detection of application map did not work that great with Oracle database (this may be a configuration issue, I haven't had time to investigate)
- UI can get sluggish some times.
- UI sometimes refuses to open a window. A reload helps. 

![Raygun](/data/2017-02-02-Choosing-centralized-logging-and-monitoring-system/raygun.png){: .logo}

### Raygun

I've decided to checked Raygun mostly because [Scot Hanselmans](), [Troy Hunts]() and [Dot Net Rocks]() recomendations.
Raygun, similary to NewRelic, hides multiple services under it's name. In this case it's **Pulse** and **Crash Report**.
Pulse is available for: Android, iOS, maxOS, JavaScript, WordPress, Xamarin.Android and Xamarin.iOS. No .NET here so I will not be exploring this path.
**Crash report** supports 27 options with most languages and platform covered(Ruby, Node, PHP, .NET, Go, ColdFusion and mobile).
 
**The good**

- the logo reminds me of an old game *Earthworm Jim*, oh the memories...:)
- very carefully designed UI.
- easy to setup (nuget package + web config changes) 

**The bad**

- at registration(demo) requiers phone number,company name, company size and role.
  
<style>
div.entry-content .logo{
	height:150px;
} 
</style>


# Summary

|---
| Service                |Google Analytics    |ELK + Graphite/Graphana|NewRelic|Retrace|Application Insights|Raygun 
|:-----------------------|:-------------------|:----------------------|:-------|:------|:-------------------|:-----
|**Logging**	     	 |
|Centralized logging     |N 				  |Y					  |Y	   | 	   |Y			 	    |
|Log querying            |N 				  |Y					  |S	   |	   |S				    |
|Custom log reports      |Y 				  |Y			    	  |S  	   |	   |S			  	    |
|:---------------------- |:-------------------|:----------------------|:-------|:------|:-------------------|:-----
|**APM**				 |
|Server side performance |Can be implemented  |Y					  |S	   |	   |Y				    |
|Browser side performance|Y 				  |N (sprawdzić czy nie ma czegoś gotowego)|		  |		  |					   |
|Enviroment performance  |Can be implemented  |Can be implemented	  |S	   |	   |Y					|
|Custom metrics          |Can be implemented  |Y					  |S	   |  	   |Y					|
|Alerts                  |N 				  |Y					  |Y	   |	   |Y					|
|Real time view          |Y 				  |Y					  |S	   |  	   |Y					|
|Custom perf. reports    |Y 				  |Y					  |S	   |	   |S					|
|:-----------------------|:-------------------|:----------------------|:-------|:------|:-------------------|:-----
|**Making life easier**  |
|Mobile access           |Y 				  |N					  |S	   |	   |Works**			    |
|OAuth                   |Y 				  |N					  |N	   |	   |N					|
|:-----------------------|:-------------------|:----------------------|:-------|:------|:-------------------|:-----
|**Features**            |
|Application map         |N 				  |N					  |Y	   |	   |Y					|
|Price                   |Free* 			  | 					  |		   |       |Free***				|

Legend:

- Can be implemented - 
- \* - Google Analytics is free up to SPRAWDZIĆ
- ** - Azure portal is usable on mobile, but not great
- *** - Application Insights are free up to GB per month, and there is a data cap and data sampling option. So it is possible to stay in the free tier.
 

## My choioce

I will admit I was blown away but what Application Insights offers. I like that it is targeted to developers although is still very accesible.
It is also one of the few options that are free, or cheep enough for me to pay from my own wallet (I'm paying ~320 $ a year for my server, so paying the same for a monitoring tool is out of the question). 
What are the things missing in Azure that would make me super happy?:

- Login with Google (this is the most popular OAuth account in the web)
- faster UI. I don't get the SPA idea in the portal. It is great when moving in scope of one module, but I would not mind a reload when going from the dashboard to AI
- more stable UI. Some windows open full screen, some open as a blade (internal Azure name)   