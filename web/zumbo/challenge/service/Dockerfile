FROM ubuntu:xenial

RUN apt-get update && apt-get install -y python-pip curl
RUN pip install flask requests gunicorn
ADD index.template /code/index.template
ADD server.py /code/server.py

# Set the flag
RUN echo "FLAG: RUNNER_ON_SECOND_BASE" > /flag
WORKDIR /code

RUN adduser --disabled-password --gecos '' ctf
RUN adduser --disabled-password --gecos '' worker

CMD ["gunicorn", "-w", "25", "-b", "0.0.0.0:5000", "--user", "worker", "server:app"]
