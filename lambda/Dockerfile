FROM public.ecr.aws/lambda/python:latest

# install python requirements 
COPY requirements.txt ./
RUN pip3 install --no-cache-dir -r requirements.txt

# copy lambda code
COPY app.py ./
CMD ["app.lambda_handler"]
