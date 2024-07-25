# on-demand-ec2

Launch AWS EC2 instance on getting API requests. 

Useful for cases when the volume of API requests is low to save cost of running EC2 instances.

## Structure

- Lambda starts EC2 instance on getting API GW call
- API GW calls Lambda and passes URL params
- Lambda makes HTTP API call to EC2 instance
- EC2 returns the response to Lambda
- Lambda returns EC2 response to API GW client
- Event Bridge stops EC2 instance if was launched more than 10 minutes ago.

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
