terraform {
  backend "s3" {
    bucket = "terraform-state-djangoapp-prod"
    key    = "prod/terraform.tfstate"
    region = "us-east-1"
  }
}
