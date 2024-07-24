# on-demand-ec2

Launch AWS EC2 instance on getting API requests. 

Useful for cases when the volume of API requests is low to save cost of running EC2 instances.

## Structure

- API GW calls Lambda and passes URL params
- Lambda starts EC2 instance
- Lambda makes HTTP API call to EC2 instance
- EC2 returns the response to Lambda
- Lambda stops EC2 instance
- Lambda returns EC2 response to API GW client

## How to use

```
tf init
tf apply -auto-approve
tf output -raw start_ec2_curl
tf output -raw query_ec2_curl
tf destroy -auto-approve
```

## Gotchas

- EC2 instance takes ~1 minute to start. First API GW call will timeout
