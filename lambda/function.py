import json
import boto3
import os

def lambda_handler(event, context):
    sqs = boto3.client('sqs')
    ec2 = boto3.client('ec2')

    # Retrieve SQS message
    queue_url = os.environ['SQS_QUEUE_URL']
    response = sqs.receive_message(
        QueueUrl=queue_url,
        MaxNumberOfMessages=1,
        WaitTimeSeconds=10
    )

    if 'Messages' not in response:
        return {'statusCode': 200, 'body': json.dumps('No messages in queue')}

    message = response['Messages'][0]
    receipt_handle = message['ReceiptHandle']

    # Launch EC2 instance
    instance_ami = os.environ['INSTANCE_AMI']
    instance_type = os.environ['INSTANCE_TYPE']

    ec2.run_instances(
        ImageId=instance_ami,
        InstanceType=instance_type,
        MinCount=1,
        MaxCount=1
    )

    # Delete message from SQS
    sqs.delete_message(
        QueueUrl=queue_url,
        ReceiptHandle=receipt_handle
    )

    return {'statusCode': 200, 'body': json.dumps('EC2 instance launched')}
