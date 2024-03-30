variable "credentials" {
  description = "US Accidents Analysis Project Credentials"
  default     = "./.keys/us_accidents_srvc_acct.json"
  #ex: if you have a directory where this file is called keys with your service account json file
  #saved there as my-creds.json you could use default = "./keys/my-creds.json"
}


variable "project" {
  description = "This is the GCP project used to do analysis on traffic \
                 accidents data across all US states from Feb 2016 - March 2023"
  default     = "us-traffic-accidents-analysis"
}

variable "region" {
  description = "Region"
  #Update the below to your desired region
  default     = "asia-south1"
}

variable "location" {
  description = "Project Location"
  #Update the below to your desired location
  default     = "APAC"
}

variable "bq_dataset_name" {
  description = "BigQuery Accident Dataset Name"
  #Update the below to what you want your dataset to be called
  default     = "bq_us_accidents_data_hrmnjm"
}

variable "gcs_bucket_name" {
  description = "My Storage Bucket Name"
  #Update the below to a unique bucket name
  default     = "gcs_us_accidents_data_hrmnjm"
}

variable "gcs_storage_class" {
  description = "Bucket Storage Class"
  default     = "STANDARD"
}