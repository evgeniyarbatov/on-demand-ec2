import os
import boto3

def lambda_handler(event, context):
    ec2 = boto3.client('ec2')
    
    instance_id = os.environ['INSTANCE_ID']
    
    instance = ec2.describe_instances(InstanceIds=[instance_id])
    instance_state = instance['Reservations'][0]['Instances'][0]['State']['Name']
    
    if instance_state == 'running':
        ec2.stop_instances(InstanceIds=[instance_id])
