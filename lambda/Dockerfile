FROM python:slim-buster

COPY requirements.txt .
RUN python3 -m pip install -r requirements.txt

RUN mkdir -p /function
COPY app.py /function

WORKDIR /function
ENTRYPOINT [ "/usr/local/bin/python", "-m", "awslambdaric" ]
CMD [ "app.lambda_handler" ]
