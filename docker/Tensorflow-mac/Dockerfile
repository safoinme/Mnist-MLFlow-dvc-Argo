FROM  kumatea/tensorflow:py39

WORKDIR /app

ADD requirements.txt /
RUN python3 -m pip install --no-cache-dir -r /requirements.txt

ENTRYPOINT ["/bin/sh"]

