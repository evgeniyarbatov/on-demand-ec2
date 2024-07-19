import json
import boto3
import os

def lambda_handler(event, context):
    ec2 = boto3.client('ec2')

    instance_ami = os.environ['INSTANCE_AMI']
    instance_type = os.environ['INSTANCE_TYPE']

    ec2.run_instances(
        ImageId=instance_ami,
        InstanceType=instance_type,
        MinCount=1,
        MaxCount=1
    )

    return {'statusCode': 200, 'body': json.dumps('EC2 instance launched')}
