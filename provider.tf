# Terraform provider

# Google compute
provider "google" {
  project     = "xxxxxxx-xxxxxx-xxxxxx"
  credentials = file("xxxxxxxxxxxx.json")
  region      = "us-central1"
  zone        = "us-central1-c"
}

# Rancher
provider "rancher2" {
  api_url = var.rancher-url
  token_key = var.rancher-token
  insecure = true
}

