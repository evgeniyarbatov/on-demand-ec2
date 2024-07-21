import requests
import boto3
import os

def lambda_handler(event, context):
    points = event["pathParameters"].get("points")
    
    geometries = event["queryStringParameters"].get("geometries")
    overview = event["queryStringParameters"].get("overview")
    
    print(points, points, overview)
    
    ec2 = boto3.client('ec2')

    instance_id = os.environ['INSTANCE_ID']
    
    ec2.start_instances(InstanceIds=[instance_id])

    waiter = ec2.get_waiter('instance_running')
    waiter.wait(InstanceIds=[instance_id])

    response = ec2.describe_instances(InstanceIds=[instance_id])
    public_dns = response['Reservations'][0]['Instances'][0]['PublicDnsName']
    
    response = requests.get(
        f"http://{public_dns}:5000/route/v1/foot/{points}", 
        params={
            'geometries': geometries,
            'overview': overview,
        }
    )
    result = response.json()
    
    ec2.stop_instances(InstanceIds=[instance_id])

    return {
        'statusCode': 200, 
        'body': result,
    }
