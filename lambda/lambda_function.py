import json
import boto3
import os

def lambda_handler(event, context):
    ec2 = boto3.client('ec2')

    instance_ami = os.environ['INSTANCE_AMI']
    instance_type = os.environ['INSTANCE_TYPE']

    response = ec2.describe_instances(
        Filters=[
            {'Name': 'image-id', 'Values': [instance_ami]},
            {'Name': 'instance-type', 'Values': [instance_type]},
        ]
    )
    
    existing_instances = [instance for reservation in response['Reservations'] for instance in reservation['Instances']]
    
    if not existing_instances:
        ec2.run_instances(
            ImageId=instance_ami,
            InstanceType=instance_type,
            MinCount=1,
            MaxCount=1
        )

    return {
        'statusCode': 200, 
        'body': {
            'status': 'ok'
        }
    }
