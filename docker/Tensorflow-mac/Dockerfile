FROM mantika/tensorflow:2.4-arm64-wheels

WORKDIR /app

ADD requirements.txt /
RUN python3 -m pip install --no-cache-dir -r /requirements.txt

ENTRYPOINT ["/bin/bash"]

