terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.8.0"
    }
  }
}


provider "google" {
  region      = "us-central1"
  project     = ""
  credentials = file("sa-tf.json")
  zone        = "us-central1-a"

}
