---
layout: post
title: Choosing centralized logging and monitoring system
description: "Searching through logs and remoting to a machine to check it's load is not a fun thing to do. This is why I've decided to look for a centralized logging service. And what I've chosen."
modified: 2017-01-30
tags: [.NET, cookit, performance, similarity, bit operations, azure, application insights]
image:
  feature: data/2017-02-02-Choosing-centralized-logging-and-monitoring-system/logo_04.jpg
---

While I'm working on the next angle on [how to speed up calculating similarities]() I started investigating how to get better telemetry from [cookit](http://cookit.pl). Getting telemetry is easy - making sense of it is the hard part. This also brought another pain point of current setup - logging and monitoring.
Since [cookit](http://cookit.pl) is my pet, nonprofit project it was time to do something.

<!--MORE-->

##**TL;TR;**
There is a [comparison table](#Comparison_table) at the end, and [what I've choose](#What_Ive_choose).

## The current state

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

# The showdown [Google Analytics](#Google_Analytics) vs. [ELK +Graphite/Grafana](#ELK) vs. [NewRelic](#NewRelic) vs. [Retrace](#Retrace) vs. [Application Insights](#Application_Insights) vs. [Raygun](#Raygun) vs. [Datadog](#Datadog):


![Google Analytics](/data/2017-02-02-Choosing-centralized-logging-and-monitoring-system/google-analytics_01.png){: .logo}

## <a name="Google_Analytics"></a>Google Analytics

Google Analytics is way more than SEO/SEM tool. With the support of custom client and server events, it can easily be turned into monitoring tool. 
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
<br/>


![ELK Stack + Graphite/Graphana](/data/2017-02-02-Choosing-centralized-logging-and-monitoring-system/elk.png){: .logo}

## <a name="ELK"></a>ELK Stack + Graphite/Graphana

ELK stack with Graphite and Grafana is the market standard for monitoring and central logging. This means that it is very easy to find Docker images, help and almost everything what is needed.
Viewing on mobile devices is possible, but far from being great, and this won't change anytime soon judging from [this Github issue](https://github.com/elastic/kibana/issues/2563). 

**The good**

- the market standard
- great visualizations (both Graphite and Kibana)
- great data crunching tools
- there are some ELK SaaS providers.
- great UI and visualization
- web based
- there are existing applications for server stats monitoring 

**The bad**

- mostly Linux based and since I am running on a Windows Server this meant getting another Linux machine. Setting every 
- most providers are not free
- a lot of stuff to manage on my own
- no out of the box monitoring
<br/>


![New Relic](/data/2017-02-02-Choosing-centralized-logging-and-monitoring-system/newRelic.svg){: .logo} 

## <a name="New_Relic"></a>New Relic

New Relic is a power horse when it comes to features. It has almost everything, from APM (Application Performance Management) to log aggregation. It is a very interesting product since it is done in a way that will be readable to nontechnical people. You automatically get notifications for apex index violations, and the UI is more like google analytics than Azure Application Insights (next)

The main dashboard:

![NewRelic panel](/data/2017-02-02-Choosing-centralized-logging-and-monitoring-system/newRelic_panel.png)

I was quite impressed with how good NewRelic inspects what went into each request. This is the Request monitoring page:
![NewRelic request details](/data/2017-02-02-Choosing-centralized-logging-and-monitoring-system/newRelic_requestDetails.png)

Another thing that is a nice feature is the Geo view. It shows how page speed differs for different geo locations. And as You can see I have a problem with Russia (have no idea why):

![NewRelic request details](/data/2017-02-02-Choosing-centralized-logging-and-monitoring-system/newRelic_geoPanel.png)  

All that is needed is the installation of a NewRelic Agent on the server. Dependencies detection and metering works out of the box, and it is the easiest tool to setup. Even browser monitoring doesn't require any additional code.

One last thing, and it may be subjective. I have the impression that after installing the NewRelic agent on the server it slowed a bit. It may be due to the fact that Application Insights is also running on it, or that my machine is just slow as it is.

To sum up - NewRelic is a powerful beast with the looks that a manager can understand :)

**The good**

- out of the box monitoring of .NET, Ruby, Node.js, PHP, Java, Python and Go applications
- Supports web and non-web applications
- Supports browser monitoring
- fast and very good UI
- Browser profiling works without the need to add a script (it is added automatically by the installed NewRelic agent)

**The bad**

- only paid version, and without all features enabled. Some are available only after contact from the sales department.
- every part is separately paid 
- at registration(demo) requires the phone number, company name, company size, and role
- uninstalling requires a machine reboot
- pricy
<br/>


![Retrace](/data/2017-02-02-Choosing-centralized-logging-and-monitoring-system/retrace.png){: .logo}

## <a name="Retrace"></a>Retrace (Stackify)

Is a product from the same guys (and girls) that develop [Prefix](https://stackify.com/prefix/), a quite good local profiler (I personally prefer MiniProfiler, but it is because I always have it in my projects).


**The good**
- for registration only Name, Surname and email are required &#128077;. Unfortunately, after email verification they want the rest &#128078;
- what is being collected by the agent is controlled from the website. So after installing the agent on the server, no additional work is required.
- nice attention to details - when installing the nLog adapter we are prompted for the key.   
- the best out of the box alert triggers from them all. The only system monitoring disk queue length. 
- machine performance alerts are correlated with requests to the application.
- fast full-text search and data analytics in logs
- option to mark an error as "fixed" 
- quite fast UI

**The bad**

- after verification, they want a whole lot of info
- I was not able to get any APM+ statistics. Everything looked properly configured
<br/>


![Application Insights](/data/2017-02-02-Choosing-centralized-logging-and-monitoring-system/ApplicationInsights.png){: .logo}

## <a name="Application_Insights"></a>Application Insights

Microsoft is investing heavily in its Azure cloud and it can be seen from the number of features they are rolling out every three months. They are investing more in the PaaS model and Application Insights fits quite good in this environment.
Application Insights feels a lot more developer orientated platform than NewRelic. It can bee easily seen that they thought more about query capabilities (AND, OR operators) than in how to get the visualizations super nice.

My customized main dashboard:
![Azure dashboard](/data/2017-02-02-Choosing-centralized-logging-and-monitoring-system/azure_panel.png)

And the request details:
![Azure dashboard](/data/2017-02-02-Choosing-centralized-logging-and-monitoring-system/azure_requestDetails.png)
As you can see all dependencies were detected neetly.

There is also one thing that strongly shows that Application Insights is targeted at IT specialists. By clicking Analyze in the top bar we can see the query behind every diagram, change it and use it for a custom report. Language used is very similar to F#. This means we have piping and support for data manipulation functions. As person using F# I must say "good move" :)
![Azure dashboard](/data/2017-02-02-Choosing-centralized-logging-and-monitoring-system/azure_querryEditor.png)

**The good**

- out of the box monitoring of sewer and browser (needs adding Google Analytics like script)
- can be added without access to the code. This does not allow full capabilities (dependency tracking and performance monitoring is available), but most of them. 
- auto detected HTTP requests and ADO queries (SQL queries)
- 1 GB a month free
- has data limits
- has sampling
- very good search feature that searches in products and instances. This is more important than one might think because the number of screens is massive. Even only in the Application Insights module.  
- customizable dashboard for every Azure offering (every panel can be moved to the main dashboard)
- the top bar has connected features. Like when you open the pricing windows it contains a to the data limit window. 

**The bad**

- detection of application map did not work that great with Oracle database (this may be a configuration issue, I haven't had time to investigate)
- UI can get sluggish sometimes.
- UI sometimes refuses to open a window. A reload helps. 
<br/>


![Raygun](/data/2017-02-02-Choosing-centralized-logging-and-monitoring-system/raygun.png){: .logo}

## <a name="Raygun"></a>Raygun

I've decided to check Raygun mostly because of Scott Hanselman's(it is even featured on the website) and  [Troy Hunt's](https://www.troyhunt.com/error-logging-and-tracking-done-right/) recommendations.
Raygun, similar to NewRelic, hides multiple services under its name. In this case, it's **Pulse** and **Crash Report**.
Pulse is available for: Android, iOS, maxOS, JavaScript, WordPress, Xamarin.Android and Xamarin.iOS. No .NET here so I will not be exploring this path.
**Crash report** supports 27 options with most languages and platform covered(Ruby, Node, PHP, .NET, Go, ColdFusion and mobile).
Raygun is definitely not a tool I was looking for, but it has it's place still. It will notify You when an error occurs and gives the possibility to mark it as fixed, but not deployed to prod. This will halt notifications of this type of errors. I see a value in this service.
 
**The good**

- the logo reminds me of an old game *Earthworm Jim*, oh the memories...:)
- very carefully designed UI.
- easy to setup (NuGet package + web config changes) 
- checking an error as fixed works quite good
- the filtering won't let You filter on a non-existing value

**The bad**

- at registration(demo) requires a phone number, company name, company size, and role.
- it is only a log aggregating mechanism
- the filtering has very little fields and only Que
<br/>  


![Application Insights](/data/2017-02-02-Choosing-centralized-logging-and-monitoring-system/Datadog.png){: .logo}

## <a name="Datadog"></a>Datadog

I've heard earlier about [Datadog](https://www.Datadoghq.com), but never checked it before. It looked good, but soon everything started going downhill (see the **The bad** section). 

It became clear quite fast that Datadog is targeted to administrators and guys having the big picture on servers that they have, not the application view I am looking for.

![Datadog dashboard](/data/2017-02-02-Choosing-centralized-logging-and-monitoring-system/Datadog_panel.png)

**The good**
- it can integrate ad monitor huge number of systems (the only tool that could monitor Solr and Docker containers)
- when I finally managed to find a dashboard it looked really good.
- very customizable dashboard. Reminds me strongly of Graphene
- it has infrastructure map
- has a free (with limited features) version up to 5 hosts.

**The bad**

- agent installation is strange.You run the command in the cmd and nothing happens. Add to it that the agent takes a few minutes to install and You end up googling why it is not working....
- agent after installation does the bare minimum. Its functionality can be extended by adding integrations on the website. This is the good part. What is not so nice is that You have to change the agent config manually on the server and change the server settings. This means a more configuration and no clean uninstall :(
- the configuration file (which You have to edit manually) is tab sensitive (??!!)
- no log aggregation
- to add an integration You have to: save the config file (edited in the agent), enable the monitoring and restart the agent.
- it took me way longer than I would wish for to get the SQL and IIS monitoring to work


<style>
div.entry-content .logo{
    height:150px;
} 
</style>


# <a name="Comparison_table"></a> Comparison table

|---
| Service                |Google Analytics    |ELK + Graphite/Graphana|NewRelic|Retrace|Application Insights|Raygun|Data dog
|:-----------------------|:-------------------|:----------------------|:-------|:------|:-------------------|:-----|
|**Logging**              |
|Centralized logging     |N                   |Y                      |Y       |Y        |Y                     |Y       |N
|Log querying            |N                   |Y                      |S       |Y       |Y                    |N*^10 |N
|Custom log reports      |Y                   |Y                      |S         |       |Y                      |N     |N
|Browser error collection|N                   |CbI*^4                   |Y         |       |[Y](https://docs.microsoft.com/en-us/azure/application-insights/app-insights-javascript)|N
|:---------------------- |:-------------------|:----------------------|:-------|:------|:-------------------|:-----|
|                         |                      |                          |           |       |                    |       |
|**APM**                 |
|Server side performance |CbI                  |Y                      |Y       |Y       |Y                    |N       |Y
|Browser side performance|Y                   |CbI *^4                   |Y       |       |[Y](https://docs.microsoft.com/en-us/azure/application-insights/app-insights-javascript)|N
|Environment performance |CbI                  |3rd party tools *^5    |Y       |Y       |Y                    |N       |N
|Custom metrics          |CbI                  |Y                      |Y       |[Y](http://support.stackify.com/hc/en-us/articles/205419705-Custom-Metrics-Overview)         |[Y*^7](https://docs.microsoft.com/en-us/azure/application-insights/app-insights-search-diagnostic-logs)|Y *^11|
|Alerts                  |N                   |Y                      |Y       |Y       |Y                    |N       |Y
|Real time view          |Y                   |Y                      |Y       |Y         |Y                    |N       |Y
|Custom perf. reports    |Y                   |Y                      |[N](https://docs.newrelic.com/docs/apm/reports)||S|N|[Y](https://www.Datadoghq.com/blog/learn-from-your-alerts-with-the-weekly-monitor-trend-report/)
|Request dependencies details|N                  |N                      |Y       |N       |                    |       |
|:-----------------------|:-------------------|:----------------------|:-------|:------|:-------------------|:-----|
|                         |                      |                          |           |       |                    |       |
|**Making life easier**  |
|Mobile access           |Y &#42;^14           |3rd party&#42;^6          |Y *^14  |N       |Works &#42;^2        |Y        |S
|OAuth                   |Y                   |N                      |N       |N       |N                    |Y        |N
|:-----------------------|:-------------------|:----------------------|:-------|:------|:-------------------|:------|
|                         |                      |                          |           |       |                    |        |
|**Features**            |
|Application map         |N                   |N                      |Y       |N       |Y                    |N        |N*^12
|Price                   |[Free with limists]((https://developers.google.com/analytics/devguides/collection/analyticsjs/limits-quotas))          |                       |150$&#42;^8|[300$](https://stackify.com/retrace/)    |Free&#42;^3            |[588$](https://raygun.com/pricing#crashreporting)|[Free*^13](https://www.Datadoghq.com/pricing/)

**Legend:**

- CbI - Can be implemented 
- *^2 - Azure portal is usable on mobile, but not mobile first ;)
- *^3 - Application Insights are free up to GB per month, and there is a data cap and data sampling option. So it is possible to stay in the free tier.
- *^4 - You have to implement the browser side and the proxy 
- *^5 - There are 3rd party tool available, although quality varies. 
- *^6 - there is An Android app [Graphitoid](https://play.google.com/store/apps/details?id=com.tnc.android.graphite&hl=en) for watching Graphite (did not try it). Kibana seems [not to work on mobile](https://discuss.elastic.co/t/kibana-charts-dashboards-not-rendering-on-mobile/48614)
- *^7 - Application Insights has three types of events: event (something happened), metric (something took x amount of time) and dependency (if auto detection didn't see this one. Can also log time)
- *^8 - NewRelics pricing is not that straight forward. It is based on the type of a machine instance and hours it will run. This is the cheapest option I could find.
- *^9 - website + infrastructure monitoring
- *^10 - it supports basic queries but doesn't allow filtering on error text, so for me, it is a NO.
- *^11 - if You log this metric as a performance counter Datadog can read it.
- *^12 - there is infrastructure map
- *^13 - the free version doesn't include alerts.
- *^14 - dedicated app

# <a name="What_Ive_choose" ></a>What I've choose?

Remember I am looking for a tool that will be used in my side project. This means I will be spending my own money, and I don't like to spend too much of it. The dislike for overspending is one of the main reasons [I am running on crapp](/The-importance-of-running-on-crapp) (it costs me ~320$ a year). So price will be important.

This said I will admit I have been blown away but what Application Insights offers. I like that it is targeted to developers although is still very accessible. Since it is the only options that are free or cheap enough for me to pay from my own wallet this is the service I will be using. I admit, there are some things that would make me smile:

- **Login with Google.** This is the most popular OAuth account on the web and would make my life a bit easier.
- **Faster UI.** I don't get the SPA idea in the portal. It is great when moving in scope of one module, but I would not mind a reload when going from the dashboard to AI
- **More stable UI.** Some windows open full screen, some open as a blade (internal Azure name)

The second place goes to NewRelic. It is expensive and not exactly what I am looking forward, but if I had to report performance to nontechnical people this would be the service I choose. It is easy, nice looking (this is more important than You think) and yet manages to deliver just enough information to get a glimpse what is happening. 
 
Next entry configuring Application Insights and it's architecture.

