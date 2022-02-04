# Defining base image
FROM python:3.9-slim-bullseye

WORKDIR /usr/app
# Installing packages from PyPi

COPY . .
RUN pip install -r requirements.txt

ENTRYPOINT ["/bin/bash"]