import os
import boto3
import datetime

def lambda_handler(event, context):
    ec2 = boto3.client('ec2')
    
    instance_id = os.environ['INSTANCE_ID']
    
    instance = ec2.describe_instances(InstanceIds=[instance_id])
    instance_state = instance['Reservations'][0]['Instances'][0]['State']['Name']
    
    if instance_state == 'running':
        launch_time = instance['Reservations'][0]['Instances'][0]['LaunchTime']
        running_duration = datetime.datetime.now(datetime.timezone.utc) - launch_time

        if running_duration > datetime.timedelta(minutes=1):
            ec2.stop_instances(InstanceIds=[instance_id])
            print(f'Stopping instance {instance_id} as it has been running for more than 1 minute.')
        else:
            print(f'Instance {instance_id} is still within the allowed running time.')
    else:
        print(f'Instance {instance_id} is not running.')
