import json
import boto3
import os

def lambda_handler(event, context):
    ec2 = boto3.client('ec2')

    instance_id = os.environ['INSTANCE_ID']

    response = ec2.describe_instances(InstanceIds=[instance_id])
    instance_state = response['Reservations'][0]['Instances'][0]['State']['Name']
    
    if instance_state == 'stopped':
        ec2.start_instances(InstanceIds=[instance_id])

    return {
        'statusCode': 200, 
        'body': {
            'status': 'ok'
        }
    }
