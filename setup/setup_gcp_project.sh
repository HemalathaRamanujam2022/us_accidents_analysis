#!/bin/bash
# This script assumes that gcloud is installed on the system
# you are running this script from.
# You can run the code "setup_gcloud_sdk.sh" to install gcloud sdk
# on Ubuntu / Debian OS. For other systems, refer to the official 
# documentation page - "https://cloud.google.com/sdk/docs/install#deb"

if [ "$#" -lt 3 ]; then
   echo "Usage:  ./create_projects.sh billingid your_GCP_email_ID"
   echo "   eg:  ./create_projects.sh 0X0X0X-0X0X0X-0X0X0X somebody@gmail.com"
   exit
fi

ACCOUNT_ID=$1
PROJECT_ID=$2
EMAIL=$3
SERVICE_ACCOUNT_NAME=us-acci-srvc-acct
KEY_FILE=~/us_accidents_analysis/.keys/us_accidents_srvc_acct.json

gcloud components update
gcloud components install alpha

gcloud config set account $EMAIL
gcloud config set project $PROJECT_ID

# echo "Creating project $PROJECT_ID for $EMAIL ... "
# Create project
# gcloud alpha projects create $PROJECT_ID
# sleep 2
# Add user to project
gcloud alpha projects get-iam-policy $PROJECT_ID --format=json > iam.json.orig
cat iam.json.orig | sed s'/"bindings": \[/"bindings": \[ \{"members": \["user:'$EMAIL'"\],"role": "roles\/editor"\},/g' > iam.json.new
gcloud alpha projects set-iam-policy $PROJECT_ID iam.json.new
# Set billing id of project
gcloud billing projects link $PROJECT_ID --billing-account=$ACCOUNT_ID

# Now we will create a service account and assign roles to the service account
# to run processes for the data pipeline

gcloud iam service-accounts create $SERVICE_ACCOUNT_NAME \
  --description="service account to run the data pipeline" \
  --display-name="us-accidents-service-account"

# Now we will assign roles one by one. Currently we can only attach one
# role at a time to the service account

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/serviceusage.serviceUsageViewer"

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/bigquery.admin"

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/cloudsql.admin"

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/dataproc.editor"

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/dataproc.worker"

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/storage.admin"

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/compute.admin"

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/iam.serviceAccountCreator"

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/iam.serviceAccountDeleter"

# We will enable all the google APIs needed for the various resources
# to be created on GCP like Big Query, Dataproc cluster, Google compute engine,
# Google cloud storage etc.
gcloud services enable cloudresourcemanager.googleapis.com \
serviceusage.googleapis.com compute.googleapis.com iam.googleapis.com \
dataproc.googleapis.com bigquery.googleapis.com --project $PROJECT_ID

gcloud iam service-accounts keys create $KEY_FILE \
    --iam-account=$SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com

gcloud auth activate-service-account --key-file=$KEY_FILE
export GOOGLE_APPLICATION_CREDENTIALS=$KEY_FILE

rm -f iam.json.*