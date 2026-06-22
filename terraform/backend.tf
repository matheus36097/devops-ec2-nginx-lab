terraform {
  backend "s3" {
    bucket  = "matheus-tfstate-ec2-nginx-lab-744574782322"
    key     = "devops-ec2-nginx-lab/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
