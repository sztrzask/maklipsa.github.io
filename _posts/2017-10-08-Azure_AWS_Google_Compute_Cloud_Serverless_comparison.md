
## Google pricing model

[Quotas](https://cloud.google.com/functions/quotas)
[Provisioning on "machines"](https://cloud.google.com/functions/pricing#compute_time)

## Azure pricing model

[Hosting comparison](https://docs.microsoft.com/en-us/azure/azure-functions/functions-scale) 
Internal messaging
Very wide integration in azure ecosystem. can be triggered by almost anything


## AWS

[Quotas](http://docs.aws.amazon.com/lambda/latest/dg/limits.html#limits-list)
## GB-s pricing model


# Comparison table

|---
| Name                			|AWS    																									|Azure																																|Google Cloud Platform
|:-----------------------		|:------------------																						|:----------------------																											|:-------
|**Serverless**             	|																											|																																	|
|Name							|[AWS Lambda](https://aws.amazon.com/lambda)																|[Azure Functions](https://azure.microsoft.com/en-us/services/functions/)															|[Cloud Functions](https://cloud.google.com/functions/)
|Deployment options   			|Manual\*1     																								|[Bitbucket,Dropbox,external/local repository, GitHub, OneDriveVSTS](https://docs.microsoft.com/en-us/azure/azure-functions/functions-continuous-deployment) 																			|[Manual](https://cloud.google.com/functions/docs/deploying/filesystem), [Google Cloud Code Repository](https://cloud.google.com/source-repositories/docs/), [GitHub,Bitbucket](https://cloud.google.com/source-repositories/docs/connecting-hosted-repositories)
|Run locally					|[In beta](http://docs.aws.amazon.com/lambda/latest/dg/test-sam-local.html) 								|[Yes](https://docs.microsoft.com/en-us/azure/azure-functions/functions-run-local)													|[Alpha](https://cloud.google.com/functions/docs/emulator)
|Pricing						|																											|																																	|
|	Billing 					|
|		Billing types			|Consumption																								|[Consumption and provisioned](https://docs.microsoft.com/en-us/azure/azure-functions/functions-scale)								|Consumption
|		Processing time			|[$0.000001667 GB-s](https://aws.amazon.com/lambda/pricing/#lambda)											|[$0.000016**/GB-s** \*3](https://azure.microsoft.com/en-us/pricing/details/functions/)												|[$0.000000231-$0.000002900](https://cloud.google.com/functions/pricing#compute_time)
|		Processing time - tics	|[100ms rounded to nearest tics](https://aws.amazon.com/lambda/pricing/#duration)							|[Every 1 second](https://azure.microsoft.com/en-us/pricing/details/functions/)														|[Every 100ms rounded up](https://cloud.google.com/functions/pricing#invocations)
|		Per call - free			|[1 million calls](https://aws.amazon.com/lambda/pricing/#lambda)											|[1 million calls/month](https://azure.microsoft.com/en-us/pricing/details/functions/)												|[First 2 million calls/month](https://cloud.google.com/functions/pricing#invocations)
|		Per call - paid			|[$0.20/million executions](https://azure.microsoft.com/en-us/pricing/details/functions/)					|[$0.20/million executions](https://azure.microsoft.com/en-us/pricing/details/functions/)											|[$0.40/million calls](https://cloud.google.com/functions/pricing)
|		Outgoing network - free	|[15GB/month **for all AWS**](https://aws.amazon.com/free/#AWS_Free_Tier_(12_Month_Introductory_Period):)	|[5GB for **all Azure**](https://azure.microsoft.com/en-us/pricing/details/bandwidth/)												|[5GB/month](https://cloud.google.com/functions/pricing#networking)
|		Outgoing network - paid	|[$0.0-$0.09 per GB](https://aws.amazon.com/ec2/pricing/on-demand/)\*4										|[$0.05-$0.175 per GB](https://azure.microsoft.com/en-us/pricing/details/bandwidth/)												|[$0.12/GB](https://cloud.google.com/functions/pricing#networking) 
|Provisioning					|																											|Consumption has no provisioning, App Service uses its [provisioning](https://docs.microsoft.com/en-us/azure/app-service/environment/app-service-web-scale-a-web-app-in-an-app-service-environment)							|[5 tiers. Memory from 128MB to 2GB. CPU from 200MHz to 2.4Ghz ](https://cloud.google.com/functions/pricing#compute_time)
|Supported languages			|[Node.js, Java, C#,Python](http://docs.aws.amazon.com/lambda/latest/dg/lambda-app.html#lambda-app-author)	|[C#, F#, Node.js](https://docs.microsoft.com/en-us/azure/azure-functions/functions-create-first-azure-function)					|[Node.js](https://cloud.google.com/functions/docs/writing/)
|Monitoring						|[CloudWatch](http://docs.aws.amazon.com/lambda/latest/dg/monitoring-functions-access-metrics.html)
|Quotas							|
|	Max execution time			|[5 minutes\*5](http://docs.aws.amazon.com/lambda/latest/dg/limits.html#limits-list)						|[Consumption plan - 10 minutes, App Service - no limit](https://docs.microsoft.com/en-us/azure/azure-functions/functions-scale) 	|[9 minutes](https://cloud.google.com/functions/quotas)
|	Deployment package size		|[50MB](http://docs.aws.amazon.com/lambda/latest/dg/limits.html#limits-list)								|																																	|[100MB(compressed) sources](https://cloud.google.com/functions/quotas#resource_limits)
|	Deployment package size w dependecies|[250MB](http://docs.aws.amazon.com/lambda/latest/dg/limits.html#limits-list)						|																																	|[500MB(uncompressed)](https://cloud.google.com/functions/quotas#resource_limits)
|	Max request size			|?																											|																																	|[10MB](https://cloud.google.com/functions/quotas#resource_limits)
|	Max response size			|?																											|																																	|[10MB](https://cloud.google.com/functions/quotas#resource_limits)
|	Max memory used				|[1536MB](http://docs.aws.amazon.com/lambda/latest/dg/limits.html#limits-list)								|																																	|[2048MB](https://cloud.google.com/functions/pricing#compute_time)
|Blue-green deployment			|																											|																																	|
|A/B testing
|Between function communication	|[Almost anything in AWS\*6](http://docs.aws.amazon.com/lambda/latest/dg/invoking-lambda-function.html)		|[Schedule, HTTP, trigger on events in: BlobStorage, Azure Event Hub, Azure Storage Queue, Azure Service Bus, Azure Cosmos DB, Microsoft Graph](https://docs.microsoft.com/en-us/azure/azure-functions/functions-triggers-bindings) |[Google Cloud Pub/Sub](https://cloud.google.com/functions/docs/writing/background) or [HTTP](https://cloud.google.com/functions/docs/writing/http)
|Trigger sources				|																											|																																	|
|**Blob storage**
|
|**Document database**
|


Legend:

\*1 - There are libraries that make it easier, but this is the out of the box solution. The other thing to note is that I didn't manage to find one definitive documentation saying what is the situation.
\*2 - In Azure [free grants apply to paid, consumption subscriptions only.](https://azure.microsoft.com/en-us/pricing/details/functions/)
\*3 - Azure computes processing time in consumption pricing this way: EXECUTION_TIME\*MEMORY 
\*4 - AWS lambda traffic charges [are priced](https://aws.amazon.com/lambda/pricing/#Additional_Charges) according to the [EC2 prices](https://aws.amazon.com/ec2/pricing/on-demand/)
\*5 - [It can be increased using AWS Support Center](http://docs.aws.amazon.com/lambda/latest/dg/limits.html#limits-list)
\*6 - [AWS supports triggers from: Amazon S3, Amazon DynamoDB, Amazon Kinesis Streams, Amazon Simple Notification Service, Amazon Simple Email Service, Amazon Cognito, AWS CloudFormation, Amazon CloudWatch Logs, Amazon CloudWatch Events, AWS CodeCommit, Scheduled Events (powered by Amazon CloudWatch Events), AWS Config, Amazon Alexa, Amazon Lex, Amazon API Gateway, AWS IoT Button, Amazon CloudFront, Amazon Kinesis Firehose](http://docs.aws.amazon.com/lambda/latest/dg/invoking-lambda-function.html)

- Azure has the best documentation. Google is very close behind, and AWS is far, far behind.