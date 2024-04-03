variable "credentials" {
  description = "US Accidents Analysis Project Credentials"
  default     = "~/us_accidents_analysis/.keys/us_accidents_srvc_acct.json"
  #ex: if you have a directory where this file is called keys with your service account json file
  #saved there as my-creds.json you could use default = "./keys/my-creds.json"
}

variable "project" {
  description = <<EOT
                 This is the GCP project used to do analysis on traffic \
                 accidents data across all US states from Feb 2016 - March 2023
                 EOT
  default     = "project-pipeline-hrmnjm"
}

variable "region" {
  description = "Region"
  #Update the below to your desired region
  default     = "asia-south1"
}

variable "zone" {
  type        = string
  description = "The zone to deploy to"
  default     = "asia-south1-a"
}

variable "location" {
  description = "Project Location"
  #Update the below to your desired location
  default     = "ASIA"
}

variable "machine_type" {
  type        = string
  description = "The machine type to deploy to"
  default     = "n2-standard-2"
}

variable "image" {
  type        = string
  description = "The image to deploy to"
  default     = "ubuntu-os-cloud/ubuntu-2004-lts"
}

variable "bq_dataset_name" {
  description = "US accidents Big Query dataset name"
  #Update the below to what you want your dataset to be called
  default     = "us_accidents_bq"
}

variable "gcs_bucket_name" {
  description = "US accidents GCS bucket name"
  #Update the below to a unique bucket name
  default     = "us_accidents_gs"
}

variable "gcs_storage_class" {
  description = "Bucket Storage Class"
  default     = "STANDARD"
}

variable "dataproc_name" {
  description = "GCP Dataproc Cluster"
  default     = "us-accidents-dataproc-cluster"
}

variable "srvc_acct_email" {
  description = "GCP Dataproc Cluster"
  default     = "us-acci-srvc-acct@us-traffic-accidents.iam.gserviceaccount.com"
}