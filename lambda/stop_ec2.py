import os
import boto3
import datetime

DURATION_LIMIT_IN_MINUTES = 10


def lambda_handler(event, context):
    instance_id = os.environ["INSTANCE_ID"]

    ec2 = boto3.client("ec2")
    instance = ec2.describe_instances(InstanceIds=[instance_id])

    instance_state = instance["Reservations"][0]["Instances"][0]["State"]["Name"]
    if instance_state != "running":
        return

    launch_time = instance["Reservations"][0]["Instances"][0]["LaunchTime"]

    duration = datetime.datetime.now(datetime.timezone.utc) - launch_time
    should_stop = duration > datetime.timedelta(minutes=DURATION_LIMIT_IN_MINUTES)

    if should_stop:
        ec2.stop_instances(InstanceIds=[instance_id])
        print(f"Stopping instance {instance_id}")
