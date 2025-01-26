import json
import boto3

def lambda_handler(event, context):
    try:
        # parser body request
        body = json.loads(event["body"])
        id = body.get("UserId")
        data = body.get("data")

        if not id or not data:
            return {
                "statusCode": 400,
                "body": json.dumps({"error": "Missing 'id' or 'data' in request"}),
            }
        # insert data on dynamodb
        dynamodb = boto3.resource(
            "dynamodb",
            region_name="us-east-1",
            endpoint_url="http://localhost:4566"  # LocalStack URL
        )   
        table = dynamodb.Table("TestTable")
        table.put_item(Item={"UserId": id, "data": data})

        return {
            "status_code": 200,
            "body": json.dumps({"status": "Data inserted succesfully"}),
        }
    except Exception as err:
        return {"statusCode": 500, "body": json.dumps({"error": str(err)})}