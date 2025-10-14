
terraform {
  backend "s3" {

    bucket         = "mahou-tf-state-homelab"
    key            = "environments/dev/terraform.tfstate"
    region         = "eu-west-1"
    encrypt        = true
    dynamodb_table = "terraform-lock-table-homelab"

  }
}