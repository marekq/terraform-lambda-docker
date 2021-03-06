import json
from aws_lambda_powertools import Logger, Tracer

# start logger and tracer of function
logger = Logger()
tracer = Tracer()

# lambda handler
@logger.inject_lambda_context(log_event = True)
@tracer.capture_lambda_handler(capture_response = True)
def lambda_handler(event, context):
	
	# return response in json
	return {
		'statusCode': 200,
		'body': json.dumps('hello from lambda')
	}
