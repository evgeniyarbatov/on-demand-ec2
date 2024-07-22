import urllib3
import boto3
import os
import json

def lambda_handler(event, context):
    instance_id = os.environ['INSTANCE_ID']
    
    points = event["pathParameters"].get("points")
    geometries = event["queryStringParameters"].get("geometries")
    overview = event["queryStringParameters"].get("overview")
    
    ec2 = boto3.client('ec2')
    response = ec2.describe_instances(InstanceIds=[instance_id])
    print(response)
    
    public_dns = response['Reservations'][0]['Instances'][0]['PublicDnsName']
    
    print(f"http://{public_dns}:5000/route/v1/foot/{points}")
    
    http = urllib3.PoolManager()
    url = f"http://{public_dns}:5000/route/v1/foot/{points}"
    params = {
        'geometries': geometries,
        'overview': overview,
    }
    encoded_params = urllib3.request.urlencode(params)

    response = http.request('GET', f"{url}?{encoded_params}")
    result = json.loads(response.data.decode('utf-8'))
    
    # ec2.stop_instances(InstanceIds=[instance_id])

    return {
        'statusCode': 200, 
        'body': result,
    }
