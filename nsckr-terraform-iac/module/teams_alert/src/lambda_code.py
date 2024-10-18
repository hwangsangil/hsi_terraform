import urllib3
import json
import logging
import os
import copy
import boto3
from datetime import datetime, timedelta

logger = logging.getLogger()
logger.setLevel(logging.ERROR)

http = urllib3.PoolManager()
URL = os.environ['webhook_url']

# Open the message template
with open('message_card_template.json') as json_file:
    message = json.load(json_file)


def lambda_handler(event, context):
    try:
        logger.debug(event)
        print(event)
        event_source = event.get('source')
        records = event.get('Records')
        
        if event_source == "aws.ecs":
            event_message = generate_message_ecs_eventbridge(event)
            send_message_to_teams(event_message)
            print("ecs")
            return True
        elif event_source == "aws.ssm":
            event_message = generate_message_ec2_patch_eventbridge(event)
            send_message_to_teams(event_message)
            return True
               
        elif records is not None:
            for record in records:
                event_source = record.get('EventSource')
                if event_source == 'aws:sns':
                    event_message = generate_message_cloudwatch(record)
                    send_message_to_teams(event_message)
                else:
                    print("Unsupported event source")
            return True

    except(KeyError, AttributeError):
        print("ERR")


def generate_message_cloudwatch(record):
    global message
    message_card = copy.deepcopy(message)
    message_card['title'] = record['Sns']['Subject']
    sns_message = json.loads(record['Sns']['Message'])
    message_card['text'] = sns_message['AlarmDescription']
    message_card['sections'][0]['facts'] = build_facts(record['Sns']['Timestamp'])
    # message_card['potentialAction'][0]['actions'][0]['targets'][0]['uri'] = \
    #     build_metric_link(record['EventSubscriptionArn'].split(':')[3], sns_message['AlarmName'])
    encoded_data = json.dumps(message_card).encode('utf-8')
    
    logger.debug(encoded_data)
    
    return encoded_data


def generate_message_ecs_eventbridge(record):
    service = str(record['resources'])
    rp_name = service.replace("'","").replace("]","")
    service_name = rp_name.split('/')[-1]
    
    kst_time = timezone_converter(record['time'])
    msg = {
            "@context": "https://schema.org/extensions",
            "@type": "MessageCard",
            "themeColor": "FF0000",
            "title": "ECS deployment failure detection",
            "text": " ",
            "summary": " ",
            "sections": [
                {
                    "facts": 
                    [
                        { 
                            "name": "Service Name : ",
                            "value": f"{service_name}"
                        },
                        {
                            "name": "State : ",
                            "value": f"{record['detail']['eventName']}"
                        },
                        {
                            "name": "Time : ",
                            "value": f"{kst_time}"
                        }
                    ]
                }
            ]
        }    
    encoded_data = json.dumps(msg).encode('utf-8')
    logger.debug(encoded_data)
    return encoded_data


def generate_message_ec2_patch_eventbridge(record):
    ec2_name=''
    client = boto3.client('ec2',region_name="ap-northeast-2")
    
    response = client.describe_instances(
    InstanceIds=[
        record['detail']['resource-id']
    ]
    ) 
    for i in response['Reservations']:
        for j in i['Instances']:
            # print(j)
            for tag in j['Tags']:
                if tag['Key'] == 'Name':
                    ec2_name = tag['Value']
                    break
                
    kst_time = timezone_converter(record['time'])
    
    msg = {
            "@context": "https://schema.org/extensions",
            "@type": "MessageCard",
            "themeColor": "FF0000",
            "title": "EC2 Patch Status is NOT COMPLIANT",
            "text": " ",
            "summary": " ",
            "sections": [
                {
                    "facts": 
                    [
                        { 
                            "name": "Resource Name : ",
                            "value": f"{ec2_name}"
                        },
                        {
                            "name": "State : ",
                            "value": f"{record['detail']['compliance-status']}"
                        },
                        {
                            "name": "Time : ",
                            "value": f"{kst_time}"
                        }
                    ]
                }
            ]
        }
    encoded_data = json.dumps(msg).encode('utf-8')
    logger.debug(encoded_data)
    return encoded_data


def send_message_to_teams(event_message):
    r = http.request(
        'POST',
        URL,
        body=event_message)
    logger.debug(r.status)
    logger.debug(r.data)
    print(r.state_change_name)


def build_facts(time_from_sns):
    time = {
        "name": "Time : ",
        "value": timezone_converter(time_from_sns)
    }
    return [time]
    
    
def timezone_converter(utc):
    utc = utc.replace(" ","")
    if '.' in utc:
        utc_format = '%Y-%m-%dT%H:%M:%S.%fZ'
    else:
        utc_format = '%Y-%m-%dT%H:%M:%SZ'
    utc_datetime = datetime.strptime(utc, utc_format)

    kst_datetime = utc_datetime + timedelta(hours=9)
    
    kst_format = '%Y-%m-%d %H:%M:%S'
    kst_time = kst_datetime.strftime(kst_format)

    return kst_time