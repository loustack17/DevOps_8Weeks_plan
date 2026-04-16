provider "google" {
  project = var.project_id
  region  = var.region
}

module "vpc" {
  source = "../../modules/vpc"

  project_id = var.project_id
  region     = var.region
  vpc_name   = "devops-vpc"
  subnet_name = "devops-subnet"
  subnet_cidr = "10.0.1.0/24"
}
