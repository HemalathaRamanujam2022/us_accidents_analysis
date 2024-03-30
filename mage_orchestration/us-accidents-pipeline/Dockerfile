FROM mageai/mageai:latest

ARG USER_CODE_PATH=/home/src/${PROJECT_NAME}
ARG GCP_SRVC_ACCT_PATH=${GCP_SRVC_ACCT_PATH}
ARG PIP=pip3

# Note: this overwrites the requirements.txt file in your new project on first run. 
# You can delete this line for the second run :) 
COPY requirements.txt ${USER_CODE_PATH}requirements.txt 

RUN  ${PIP} install -r ${USER_CODE_PATH}requirements.txt
RUN  ${PIP} install kaggle pyspark

# The following code is to integrate Spark inside Mage
# Add Debian Bullseye repository
RUN echo 'deb http://deb.debian.org/debian bullseye main' > /etc/apt/sources.list.d/bullseye.list

# Install OpenJDK 11
RUN apt-get update -y && \
    apt-get install -y openjdk-11-jdk

# Remove Debian Bullseye repository
RUN rm /etc/apt/sources.list.d/bullseye.list

# https://github.com/kubeflow/spark-operator/blob/94775cd89ca0158e869fac39e1b097d1bf56a7e8/spark-docker/Dockerfile#L28
# Add the connector jar needed to access Google Cloud Storage using the Hadoop FileSystem API.
# ADD https://storage.googleapis.com/hadoop-lib/gcs/gcs-connector-latest-hadoop2.jar ./jars
# ADD https://storage.googleapis.com/spark-lib/bigquery/spark-bigquery-latest_2.12.jar ./jars
# Manually downloaded the above jars into current folder using wget
COPY gcs-connector-latest-hadoop2.jar /home/src/jars/gcs-connector-latest-hadoop2.jar 
COPY spark-bigquery-latest_2.12.jar /home/src/jars/spark-bigquery-latest_2.12.jar
RUN chmod 644 /home/src/jars/gcs-connector-latest-hadoop2.jar /home/src/jars/spark-bigquery-latest_2.12.jar

# The following code is for installing gcloud CLI
# Install prerequisites
# RUN apt-get update && apt-get install -y \
# curl
# CMD /bin/bash
RUN curl https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz > /tmp/google-cloud-sdk.tar.gz
# RUN apt-get update && apt-get install -y python3 python3-pip
RUN mkdir -p /usr/local/gcloud
RUN tar -C /usr/local/gcloud -xvf /tmp/google-cloud-sdk.tar.gz
RUN /usr/local/gcloud/google-cloud-sdk/install.sh
# Adding the package path to local
ENV PATH $PATH:/usr/local/gcloud/google-cloud-sdk/bin
# ENV GCP_SRVC_ACCT_PATH /home/src/.config/gcloud/mage_srvc_acct.json
# RUN gcloud auth activate-service-account  --key-file=${KEY_FILE_NAME}


# COPY install_dependencies.sh ${USER_CODE_PATH}install_dependencies.sh
# RUN ${USER_CODE_PATH}install_dependencies.sh /home/src
# CMD ["sh", "/home/src/install_dependencies.sh /home/src"]
