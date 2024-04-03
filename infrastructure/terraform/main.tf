terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.6.0"
    }
  }
}

provider "google" {
  credentials = file(var.credentials)
  project     = var.project
  region      = var.region
  zone        = var.zone
}


resource "google_compute_instance" "test-machine" {
  name         = "us-accidents-test-machine"
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = var.image
      size = 30
      labels = {
        }
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }
}



/*
# Not able to create datproc cluster from terraform. Will have to 
# do it manually
resource "google_service_account" "default" {
  account_id   = "dp-srvc-acct"
  display_name = "service account for creating dataproc cluster"
}

resource "google_project_iam_member" "dp_clus_acct_binding" {
  project = var.project
  for_each = toset([ 
          "roles/editor",  
          "roles/storage.admin",
          "roles/storage.object.admin",
          "roles/storage.object.creator",
          ])
  role    = each.value
  member = "serviceAccount:${google_service_account.default.email}"
}

#resource "google_project_iam_member" "dp_clus_acct_binding" {
#  project = var.project
#  role    = "roles/dataproc.editor"
#  member  = "serviceAccount:${google_service_account.default.email}"
#}



resource "google_dataproc_cluster" "dp_clus" {  
  name     = var.dataproc_name
  region   = var.region
  graceful_decommission_timeout = "120s"

  cluster_config {
    gce_cluster_config {
    zone = var.zone
    internal_ip_only = false
    #service_account = google_service_account.default.email
    #service_account_scopes = [
    #   "cloud-platform"
    # ]
    }

    master_config {
      num_instances = 1
      machine_type  = var.machine_type
      disk_config {
        boot_disk_type    = "pd-ssd"
        boot_disk_size_gb = 30
      }
    }

    software_config {
      image_version = "2.2-debian12"
      override_properties = {
        "dataproc:dataproc.allow.zero.workers" = "false"
      }
    }
    

    # You can define multiple initialization_action blocks
    initialization_action {
      script      = "gs://dataproc-initialization-actions/stackdriver/stackdriver.sh"
      timeout_sec = 500
    }
  }
}
*/



# For GCS, the location type is Region
resource "google_storage_bucket" "demo-bucket" {
  name          = var.gcs_bucket_name
  location      = var.region
  force_destroy = true


  lifecycle_rule {
    condition {
      age = 90
    }
    action {
      type = "AbortIncompleteMultipartUpload"
    }
  }
  
}

resource "google_bigquery_dataset" "demo_dataset" {
  dataset_id = var.bq_dataset_name
  location   = var.region
}




