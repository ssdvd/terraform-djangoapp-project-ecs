terraform {
  backend "s3" {
    bucket = "terraform-state-djangoapp-dev"
    key    = "dev/terraform.tfstate"
    region = "us-east-1"
  }
}
