FROM python:3.9.4-buster

RUN useradd --create-home sayless

WORKDIR /home/sayless

USER sayless

CMD ["/home/sayless/.local/bin/uwsgi", "/home/sayless/src/uwsgi.ini"]

ADD ./images/requirements.txt /home/requirements.txt

RUN pip install -r /home/requirements.txt

ADD ./src /home/sayless/src

