FROM apache/spark-py:v3.3.1

## Switch to root user to install Python 3.10
USER root

# RUN apt-get update -y
# RUN apt-get install python3.10 -y
# RUN apt-get clean -y
RUN apt-get update 
RUN apt-get install software-properties-common -y
RUN add-apt-repository ppa:deadsnakes/ppa -y
RUN apt-get update 
RUN apt-get install -y python3.10 python3.10-venv python3.10-dev curl

# Update symlink to make python3 point to 3.10
RUN ln -sf /usr/bin/python3.10 /usr/bin/python3

# Install pip for the new version
RUN curl -sS https://bootstrap.pypa.io/get-pip.py | python3.10

## Switch back to the non-root user
USER 185