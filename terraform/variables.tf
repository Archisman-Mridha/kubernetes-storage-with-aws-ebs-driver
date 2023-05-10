variable "project_name" {
  default = "kubernetes-storage-with-aws-ebs-driver"
}

variable "aws_access_key" {
  type = string
}

variable "aws_secret_key" {
  type = string
}

variable "aws_region" {
  default = "us-east-1"
}
