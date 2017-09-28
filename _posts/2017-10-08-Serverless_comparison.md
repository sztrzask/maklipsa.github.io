
## Google pricing model

[Quotas](https://cloud.google.com/functions/quotas)

## Azure pricing model

[Hosting comparison](https://docs.microsoft.com/en-us/azure/azure-functions/functions-scale) 


## GB-s pricing model


# Comparison table

|---
| Name                			|AWS    																	|Azure																																|Google Cloud Platform
|:-----------------------		|:------------------														|:----------------------																											|:-------
|**Serverless**             	|																			|																																	|
|Name							|[AWS Lambda](https://aws.amazon.com/lambda)								|[Azure Functions](https://azure.microsoft.com/en-us/services/functions/)															|[Cloud Functions](https://cloud.google.com/functions/)
|Deployment options   			|Manual\*1     																|[Bitbucket,Dropbox,external/local repository, GitHub, OneDriveVSTS](https://docs.microsoft.com/en-us/azure/azure-functions/functions-continuous-deployment) 																			|[Manual](https://cloud.google.com/functions/docs/deploying/filesystem), [Google Cloud Code Repository](https://cloud.google.com/source-repositories/docs/), [GitHub,Bitbucket](https://cloud.google.com/source-repositories/docs/connecting-hosted-repositories)
|Run locally					|[In beta](http://docs.aws.amazon.com/lambda/latest/dg/test-sam-local.html) |[Yes](https://docs.microsoft.com/en-us/azure/azure-functions/functions-run-local)													|[Alpha](https://cloud.google.com/functions/docs/emulator)
|Pricing						|																			|																																	|
|	Billing 					|
|		Billing types			|																							|[Consumption and provisioned](https://docs.microsoft.com/en-us/azure/azure-functions/functions-scale)								|Consumption
|		Processing time			|[$0.000001667 GB-s](https://aws.amazon.com/lambda/pricing/#lambda)							|[$0.000016**/GB-s** \*3](https://azure.microsoft.com/en-us/pricing/details/functions/)												|[$0.000000231-$0.000002900](https://cloud.google.com/functions/pricing#compute_time)
|		Processing time - tics	|[100ms rounded to nearest tics](https://aws.amazon.com/lambda/pricing/#duration)			|[Every 1 second](https://azure.microsoft.com/en-us/pricing/details/functions/)														|[Every 100ms rounded up](https://cloud.google.com/functions/pricing#invocations)
|		Per call - free			|[1 million calls](https://aws.amazon.com/lambda/pricing/#lambda)							|[1 million calls/month](https://azure.microsoft.com/en-us/pricing/details/functions/)												|[First 2 million calls/month](https://cloud.google.com/functions/pricing#invocations)
|		Per call - paid			|[$0.20/million executions](https://azure.microsoft.com/en-us/pricing/details/functions/)	|[$0.20/million executions](https://azure.microsoft.com/en-us/pricing/details/functions/)											|[$0.40/million calls](https://cloud.google.com/functions/pricing)
|		Outgoing network - free	|																							|[5GB for **all Azure**](https://azure.microsoft.com/en-us/pricing/details/bandwidth/)												|[5GB/month](https://cloud.google.com/functions/pricing#networking)
|		Outgoing network - paid	|																							|[$0.05-$0.175 per GB](https://azure.microsoft.com/en-us/pricing/details/bandwidth/)												|[$0.12/GB](https://cloud.google.com/functions/pricing#networking) 
|Provisioning					|																							|Consumption has no provisioning, App Service uses its [provisioning](https://docs.microsoft.com/en-us/azure/app-service/environment/app-service-web-scale-a-web-app-in-an-app-service-environment)							|[5 tiers. From 128MB to 2Gb](https://cloud.google.com/functions/pricing#compute_time)
|Supported languages			|																							|[C#, F#, Node.js](https://docs.microsoft.com/en-us/azure/azure-functions/functions-create-first-azure-function)					|[Node.js](https://cloud.google.com/functions/docs/writing/)
|Max execution time				|																							|[Consumption plan - 10 minutes, App Service - no limit](https://docs.microsoft.com/en-us/azure/azure-functions/functions-scale) 	|[9 minutes](https://cloud.google.com/functions/quotas)
|Monitoring
|Blue-green deployment
|A/B testing
|**Messaging**
|
|**Blob storage**
|
|**Document database**
|


Legend:

\*1 - There are libraries that make it easier, but this is the out of the box solution. The other thing to note is that I didn't manage to find one definitive documentation saying what is the situation.
\*2 - In Azure [free grants apply to paid, consumption subscriptions only.](https://azure.microsoft.com/en-us/pricing/details/functions/)
\*3 - Azure computes processing time in consumption pricing this way: EXECUTION_TIME\*MEMORY 

Overall:

- Azure has the best documentation. Google is very close behind, and AWS is far, far behind.