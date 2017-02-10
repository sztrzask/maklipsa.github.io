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

One last thing, and it may be subjective. I have the impression that after installing NewRelic agent on the server it slowed a bit. It may be due to the fact that Application Insights is also running on it, or that my machine is just slow as it is.

To sum up - NewRelic is a powerfull beast.

**The good**

- out of the box monitoring of .NET,Ruby, Node.js, PHP, Java, Python and Go applications
- Supports web and non-web applications
- Supports browser monitoring
- fast and very good UI
- Browser profiling works without the need to add a script (it is added automaticly by the installed NewRelic agent)

**The bad**

- only paid version, and without all features enabled. Some are available only after contact from the sales department.
- every part is seperatly paid 
- at registration(demo) requiers phone number,company name, company size and role
- uninstalling requiers a rebot
- pricy

![Retrace](/data/2017-02-02-Choosing-centralized-logging-and-monitoring-system/retrace.png){: .logo}

### Retrace

Is a product from the same guys (and girls) that develop [Prefix](https://stackify.com/prefix/), a quite good local profiler (I personally prefer MiniProfiler, but it is because I always have it in my projects).


**The good**
- for registration only Name, Surname and email is requiered &#128077;. Unfortunetly after email verification they want the rest &#128078;
- what is being collected by the agent is controlled from the website. So after installing the agent on the server no additional work is required.
- nice attention to details - when installing the nLog adopter we are promped for the key.   
 
**The bad**

- after verification they want a whole lot of info
- I'm not a fan of a dark theme (yes, this is a personal comparison, so it is a valid point)

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
Raygun is deffinetly not a tool I was looking for, but it has it's place still. It will notify You when an error occures and gives the possibility to mark it as fixed, but not deployed to prod. This will halt notifications of this type of errors. I see a value in this service.
 
**The good**

- the logo reminds me of an old game *Earthworm Jim*, oh the memories...:)
- very carefully designed UI.
- easy to setup (nuget package + web config changes) 
- checking an error as fixed works quite good
- the filtering won't let You filter on an non existing value
-   
**The bad**

- at registration(demo) requiers phone number,company name, company size and role.
- it is only a log aggregating mechanism
- the filtering has very little fields and only Que
  

![Application Insights](/data/2017-02-02-Choosing-centralized-logging-and-monitoring-system/Datadog.png){: .logo}

# DataDog

I've heard earlier about DataDog, but never checked it before. It looked good, but soon everything started going down hill (see the **The bad** section). 

It became clear quite fast that Datadog is targeted to administrators and guys having the big picture on servers that they have, not the application view I am looking for.

![DataDog dashboard](/data/2017-02-02-Choosing-centralized-logging-and-monitoring-system/Datadog_panel.png)

**The good**
- it can integrate ad monitor huge number of systems (the only tool that could monitor Solr and Docker containers)
- when I finally managed to find a dashboard it looked really good.
- very customizable dashboard. Reminds me strongly of Graphene
- it has infrastructure map
- has a free (with limited features) version up to 5 hosts.

**The bad**

- agent installation is strange.You run the command in the cmd and nothing happenes. Add to it that the agent takes a few minutes to install and You end up googling why it is not working....
- agent after installation does the bare minimum. It's functionallity can be extended by adding integrations on the website. This is the good part. What is not so nice is that You have to change the agent config manually on the server and change the server settings. This means a more configuration and no clean uninstall :(
- the configuration file (which You have to edit manually) is tab sensitive (??!!)
- no log aggregation
- to add an integration You have to: save the config file (edited in the agent), enable the monitoring and restart the agent.
- it took me way longer than I would wish for to get the sql and IIS monitoring to work


<style>
div.entry-content .logo{
	height:150px;
} 
</style>


# Summary

|---
| Service                |Google Analytics    |ELK + Graphite/Graphana|NewRelic|Retrace|Application Insights|Raygun|Data dog
|:-----------------------|:-------------------|:----------------------|:-------|:------|:-------------------|:-----|
|**Logging**	     	 |
|Centralized logging     |N 				  |Y					  |Y	   | 	   |Y			 	    |Y	   |N
|Log querying            |N 				  |Y					  |S	   |	   |Y				    |N*^10 |N
|Custom log reports      |Y 				  |Y			    	  |S  	   |	   |Y			  	    |N     |N
|Browser error collection|N 				  |Can be implemented*^4 |Y  	   |	   |[Y](https://docs.microsoft.com/en-us/azure/application-insights/app-insights-javascript)|N
|:---------------------- |:-------------------|:----------------------|:-------|:------|:-------------------|:-----|
|**APM**				 |
|Server side performance |Can be implemented  |Y					  |Y	   |	   |Y				    |N	   |Y
|Browser side performance|Y 				  |Can be implemented*^4  |Y       |       |[Y](https://docs.microsoft.com/en-us/azure/application-insights/app-insights-javascript)|N
|Environment performance |Can be implemented  |3rd party tools *^5    |Y	   |	   |Y					|N	   |N
|Custom metrics          |Can be implemented  |Y					  |Y	   |  	   |[Y*^7](https://docs.microsoft.com/en-us/azure/application-insights/app-insights-search-diagnostic-logs)|Y *^11|
|Alerts                  |N 				  |Y					  |Y	   |	   |Y					|N	   |Y
|Real time view          |Y 				  |Y					  |Y	   |  	   |Y					|N	   |Y
|Custom perf. reports    |Y 				  |Y					  |[N](https://docs.newrelic.com/docs/apm/reports)||S|N|[Y](https://www.datadoghq.com/blog/learn-from-your-alerts-with-the-weekly-monitor-trend-report/)
|:-----------------------|:-------------------|:----------------------|:-------|:------|:-------------------|:-----
|**Making life easier**  |
|Mobile access           |Y 				  |3rd party&#42;^6		  |Y (dedicated app) ||Works &#42;^2	|Y	    |S
|OAuth                   |Y 				  |N					  |N	   |	   |N					|Y	    |N
|:-----------------------|:-------------------|:----------------------|:-------|:------|:-------------------|:------|
|**Features**            |
|Application map         |N 				  |N					  |Y	   |	   |Y					|N	    |N*^12
|Price                   |Free&#42;			  | 					  |150$&#42;^8|    |Free&#42;^3			|[588$](https://raygun.com/pricing#crashreporting)|[Free*^13](https://www.datadoghq.com/pricing/)

Legend:

- Can be implemented - 
- \* - Google Analytics is free up to 200,000 per user per day. [Full quotas](https://developers.google.com/analytics/devguides/collection/analyticsjs/limits-quotas)
- *^2 - Azure portal is usable on mobile, but not great
- *** - Application Insights are free up to GB per month, and there is a data cap and data sampling option. So it is possible to stay in the free tier.
- *^4 - You have to implement the browser side and the proxy 
- *^5 - There are 3rd party tool available, although quality varies. 
- *^6 - there is An Android app [Graphitoid](https://play.google.com/store/apps/details?id=com.tnc.android.graphite&hl=en) for watching Graphite (did not try it). Kibana seems [not to work on mobile](https://discuss.elastic.co/t/kibana-charts-dashboards-not-rendering-on-mobile/48614)
- *^7 - Application Insights has three types of events: event (something happened), metric (something took x amount of time) and dependency (if auto detection didn't see this one. Can also log time)
- *^8 - NewRelics pricing is not that straight forward. It is based on an type of a machine instance and hours it will run. This is the cheapest option I could find.
- *^9 - website + infrastructure monitoring
- *^10 - it supports basic queries, but doesn't allow filtering on error text, so for me it is a no.
- *^11 - if You log this metric as a performance counter Datadog can read it.
- *^12 - there is infrastructure map
- *^13 - the free version doesn't include alerts.

## My choioce

Remember I am looking for a tool that will be used in my side project. This means I will be spending my own money, and I don't like to spend to much of it. Dislike for over spending is one of the main reasons [I am running on crapp]() (it costs me ~320$ a year). So price will be important.

This said I will admit I was blown away but what Application Insights offers. I like that it is targeted to developers although is still very accesible. Since it is the only options that are free, or cheep enough for me to pay from my own wallet this is the service I will be using. I admit, there are some things that would make me smile:

- **Login with Google.** This is the most popular OAuth account in the web and would make my life a bit easier.
- **Faster UI.** I don't get the SPA idea in the portal. It is great when moving in scope of one module, but I would not mind a reload when going from the dashboard to AI
- **More stable UI.** Some windows open full screen, some open as a blade (internal Azure name)

The second place goes to NewRelic. It is expensive and not exactly what I am looking forward, but if I had to report performance to non technical people this would be the service I choose. It is easy, nice looking (this is more important than You think) and yet manages to deliver just enough information to get a glimpse what is happening. 
 
Next entry configuring Application Insights and it's architecture.

