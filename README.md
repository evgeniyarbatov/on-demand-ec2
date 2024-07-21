# on-demand-ec2

Launch AWS EC2 instance on getting API requests. 

Usesul for cases when the volume of API requests is low to save cost of running EC2 instances.

## Structure

- API GW calls Lambda function and passes URL params
- Lambda function starts EC2 instance
- Lambda HTTP API on EC2 instance with URL params from API GW
- EC2 returns the response to Lambda
- Lambda stops EC2 instance
- Lambda returns EC2 response to API GW client

## How to use

```
tf init
tf apply -auto-approve
tf output -raw curl
tf destroy -auto-approve
```
