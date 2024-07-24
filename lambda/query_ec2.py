import urllib3
import boto3
import os

def lambda_handler(event, context):
    instance_id = os.environ['INSTANCE_ID']
    
    points = event["pathParameters"].get("points")
    geometries = event["queryStringParameters"].get("geometries")
    overview = event["queryStringParameters"].get("overview")
    
    ec2 = boto3.client('ec2')

    waiter = ec2.get_waiter('instance_running')
    waiter.wait(InstanceIds=[instance_id])
    
    response = ec2.describe_instances(InstanceIds=[instance_id])    
    public_dns = response['Reservations'][0]['Instances'][0]['PublicDnsName']
    
    http = urllib3.PoolManager()
    url = f"http://{public_dns}:5000/route/v1/foot/{points}"
    params = {
        'geometries': geometries,
        'overview': overview,
    }
    encoded_params = urllib3.request.urlencode(params)
    response = http.request('GET', f"{url}?{encoded_params}")    
    result = response.data.decode('UTF-8')

    return {
        'statusCode': 200, 
        'body': result,
    }
