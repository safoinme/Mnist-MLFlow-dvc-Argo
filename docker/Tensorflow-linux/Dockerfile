FROM ubuntu:20.04 as base

ENV DEBIAN_FRONTEND=noninteractive

# See http://bugs.python.org/issue19846
ENV LANG C.UTF-8


#ARG DVC_AWS_ACCESS_KEY_ID
#ARG DVC_AWS_SECRET_ACCESS_KEY

#ARG MLFLOW_TRACKING_URI
#ARG MLFLOW_S3_ENDPOINT_URL
#ARG AWS_ACCESS_KEY_ID
#ARG AWS_SECRET_ACCESS_KEY

#ARG GIT_REPO


WORKDIR /app


RUN apt-get update && apt-get install -y curl python3 python3-pip && \
    ln -s $(which python3) /usr/local/bin/python && \
    pip3 --no-cache-dir install --upgrade setuptools \ 
    grcpio==1.36.1 tensorflow -f https://tf.kmtea.eu/whl/stable.html



COPY requirements.txt .

RUN python3 -m pip install --no-cache-dir -r requirements.txt

ENTRYPOINT ["/bin/sh"]





