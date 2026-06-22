variable "aws_region" {
  default = "us-east-1"
}

variable "project_name" {
  default = "devops-ec2-nginx-lab"
}

variable "subnet_id" {
  default = "subnet-0452c1968b3ce69c8"
}

variable "security_group_id" {
  default = "sg-0638ac993b66d6b52"
}

variable "instance_type" {
  default = "t2.micro"
}
