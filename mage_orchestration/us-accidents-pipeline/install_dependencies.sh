#!/bin/bash

# initial updates
# sudo apt-get update -y
# sudo apt-get upgrade -y
# sudo apt-get install unzip -y

# export USER_HOME=$1

# Java runtime for Apache Spark
wget https://download.java.net/java/GA/jdk11/9/GPL/openjdk-11.0.2_linux-x64_bin.tar.gz
mkdir ${PWD}/spark
tar xzfv openjdk-11.0.2_linux-x64_bin.tar.gz -C ${PWD}/spark/
rm openjdk-11.0.2_linux-x64_bin.tar.gz
# export PATH
export JAVA_HOME="${PWD}/spark/jdk-11.0.2"
export PATH="${JAVA_HOME}/bin:${PATH}"

# Spark 
wget https://archive.apache.org/dist/spark/spark-3.3.2/spark-3.3.2-bin-hadoop3.tgz
tar xzfv spark-3.3.2-bin-hadoop3.tgz -C ${PWD}/spark/
rm spark-3.3.2-bin-hadoop3.tgz
# export path
export SPARK_HOME="${PWD}/spark/spark-3.3.2-bin-hadoop3"
export PATH="${SPARK_HOME}/bin:${PATH}"

#Pyspark
export PYTHONPATH="${SPARK_HOME}/python/:$PYTHONPATH"
export PYTHONPATH="${SPARK_HOME}/python/lib/py4j-0.10.9.5-src.zip:$PYTHONPATH"

# Authenticate gcloud services account
gcloud auth activate-service-account  --key-file=/home/src/${GCP_SRVC_ACCT_KEY}