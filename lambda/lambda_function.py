import json
import boto3
import os

def lambda_handler(event, context):
    ec2 = boto3.client('ec2')

    points = event["pathParameters"].get("points")
    print(points)

    instance_id = os.environ['INSTANCE_ID']

    ec2.start_instances(InstanceIds=[instance_id])
    
    ec2.stop_instances(InstanceIds=[instance_id])

    return {
        'statusCode': 200, 
        'body': {
            'status': 'ok'
        }
    }
