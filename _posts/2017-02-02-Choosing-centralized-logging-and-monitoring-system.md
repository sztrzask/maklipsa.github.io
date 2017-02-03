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
- no collecting of system performance counters (can be easily written, but still a minus)
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
- every part is seperatly paid. 

![Retrace](/data/2017-02-02-Choosing-centralized-logging-and-monitoring-system/retrace.png){: .logo}

### Retrace
**The good**

**The bad**

![Application Insights](/data/2017-02-02-Choosing-centralized-logging-and-monitoring-system/ApplicationInsights.png){: .logo}

### Application Insights

Microsoft is investing heavily in it's Azure cloud. And it has a lot of PAS applications to show. 
Microsofts Azure is, or has, became a place where almost any need can be fulfilled.
I've heard about Microsoft's solution because of it's query language for logs  

**The good**

- out of the box monitoring of sever and browser (needs adding Google Analytics like script) 
- auto detected HTTP requests to Solr and SQL Server queries
- 1 GB a month free
- has data limits
- has sampling
- search allows to navigate to any windows (it is really helpful because it has a lot of features and subscreans)

**The bad**

- detection of application map did not work that great with Oracle database
- UI is sometimes a bit slugish
- 

![Raygun](/data/2017-02-02-Choosing-centralized-logging-and-monitoring-system/raygun.png){: .logo}

### Raygun


<style>
div.entry-content .logo{
	height:150px;
} 
</style>


