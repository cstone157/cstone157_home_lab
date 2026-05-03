FROM apache/spark-py:v3.3.1

## Switch to root user to install Python 3.10
USER root

RUN apt-get update 
RUN apt install build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev libsqlite3-dev wget libbz2-dev -y
RUN wget https://python.org/ftp/python/3.10.14/Python-3.10.14.tgz
RUN tar -xf Python-3.10.14.tgz
# RUN cd Python-3.10.14
WORKDIR /opt/spark/work-dir/Python-3.10.14
RUN ./configure --enable-optimizations
RUN make -j $(nproc)
# RUN make altinstall
RUN make install
# RUN cd ..


## Switch back to the non-root user
WORKDIR /opt/spark/work-dir/
USER 185