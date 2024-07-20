import json
import boto3
import os

def lambda_handler(event, context):
    ec2 = boto3.client('ec2')

    instance_id = os.environ['INSTANCE_ID']
    type = os.environ['TYPE']
    
    if type == 'start':
        ec2.start_instances(InstanceIds=[instance_id])
    elif type == 'stop':
        ec2.stop_instances(InstanceIds=[instance_id])
    elif type == 'proxy':
        points = event["pathParameters"].get("points")

    return {
        'statusCode': 200, 
        'body': {
            'status': 'ok'
        }
    }
