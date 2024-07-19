# on-demand-ec2

Launch AWS EC2 instance on getting API requests. 

Usesul for cases when the volume of API requests is low to save cost running EC2 instances.

Ex: your have a Streamlit app which you host with [Streamlit Community Cloud](https://streamlit.io/cloud) and you need an EC2 instance.

## Structure

- API GW calls Lambda function
- Lambda function launches EC2 instance
- EC2 instance does processing
- EC2 publishes the result to SNS topic

## How to use

```
tf init
tf apply -auto-approve
tf output -raw curl
tf destroy -auto-approve
```
