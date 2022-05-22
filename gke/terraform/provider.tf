terraform {
  required_version = "~> 1.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 4.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

provider "google-beta" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}
/*

module "cloud-storage" {
  source  = "terraform-google-modules/cloud-storage/google"
  version = "2.1.0"
  project_id = var.project_id
  names = ["terraform-${var.project_id}"]
  prefix = "terraform-${var.project_id}"
}

terraform {
  backend "gcs" {
    bucket  = "terraform-eu-terraform"
    prefix  = "terraform/state"
  }
}*/
