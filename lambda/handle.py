import json
import boto3


def lambda_handler(event, context):
    try:
        print("Received event:", json.dumps(event))

        body = json.loads(event["body"])
        id = body.get("UserId")
        data = body.get("data")

        dynamodb = boto3.resource(
            "dynamodb",
            region_name="us-east-1",
            endpoint_url="http://host.docker.internal:4566",  # LocalStack URL
        )

        table = dynamodb.Table("TestTable")
        response = table.put_item(Item={"UserId": id, "data": data})
        print(f"DynamoDB Response: {response}")

        return {
            "statusCode": 200,
            "body": json.dumps({"status": "Data inserted successfully"}),
        }

    except Exception as err:
        print("Error:", str(err))
        return {"statusCode": 500, "body": json.dumps({"error": str(err)})}
