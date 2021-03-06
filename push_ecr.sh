# refresh terraform output
terraform refresh

# get variables from terraform
ecr_repo=$(terraform output ecr_repo | tr -d '"')
lambda_function=$(terraform output this_lambda_function_name | tr -d '"')
aws_region=$(terraform output aws_region | tr -d '"')
apigateway_url=$(terraform output apigateway_url | tr -d '"')

# print retrieved variables
echo 'using '$ecr_repo' '$lambda_function' '$aws_region' '$apigateway_url

# login to ECR
aws ecr get-login-password --region $aws_region | docker login --username AWS --password-stdin $ecr_repo

# build Docker image from local Dockerfile
docker build -t $lambda_function ./lambda

# tag and push the docker image
docker tag $lambda_function:latest $ecr_repo:latest
docker push $ecr_repo:latest

# update lambda to new code base
echo 'Updating Lambda code'
cmd=$(aws lambda update-function-code --function-name $lambda_function --image-uri $ecr_repo:latest)

# wait until the function is deployed by checking Lambda api
while [[ 'true' ]]
do
    var=$(aws lambda get-function --function-name $lambda_function | grep -o InProgress)
    echo 'Lambda Update Status:' $var

    if [[ $var == "" ]]
    then

        # completed, return API Gateway URL
        echo 'done updating '$apigateway_url

        # perform a get request on the API
        curl $apigateway_url

        exit
        
    fi

    # wait 3 seconds between retries
    sleep 3

done
