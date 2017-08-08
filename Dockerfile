FROM phusion/baseimage
MAINTAINER Mahmood Aghapour <itismahmood@gmai.com>

RUN apt-get update \
    && apt-get install -y --auto-remove --no-install-recommends curl openjdk-8-jdk libgfortran3 python-pip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV PIO_VERSION 0.11.0
ENV SPARK_VERSION 1.6.3
ENV ELASTICSEARCH_VERSION 1.7.6
ENV HBASE_VERSION 1.2.6

ENV PIO_HOME /PredictionIO-${PIO_VERSION}-incubating
ENV PATH=${PIO_HOME}/bin:$PATH
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

ENV MYPIO_TAR=v${PIO_VERSION}-incubating.tar.gz

RUN cd / && curl -L -O https://github.com/apache/incubator-predictionio/archive/${MYPIO_TAR} \
    && tar -xvzf ${MYPIO_TAR} -C / \
    && rm ${MYPIO_TAR} \
    && mv incubator-predictionio-${PIO_VERSION}-incubating apache-predictionio-${PIO_VERSION}-incubating \
    && cd /apache-predictionio-${PIO_VERSION}-incubating \
    && ./make-distribution.sh
