FROM python:3.9.4-buster

ADD ./images/requirements.txt /home/requirements.txt

RUN pip install -r /home/requirements.txt

ADD ./src /home/src

ENV FLASK_APP=/home/src/app.py
