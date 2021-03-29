provider "google" {
  version = "~> 3.61.0"
  region  = var.region
  project = var.project
  credentials = file ("gcpkey.json")
}

provider "random" {
  version = "~> 3.1.0"
}

provider "null" {
  version = "~> 3.1.0"
}

provider "kubernetes" {
  #version = "~> 2.0.3"
}
