terraform {
  required_version = "1.4.6"

  backend "local" { }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.66.1"
    }
  }
}

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key

  region = var.aws_region

  default_tags {
    tags = {
      project = var.project_name
    }
  }
}

module "self_managed_k8s_cluster" {
  source  = "Archisman-Mridha/self-managed-k8s/aws"
  version = "0.1.2"

  project_name = var.project_name

  aws_access_key = var.aws_access_key
  aws_secret_key = var.aws_secret_key

  aws_region = var.aws_region
  aws_zones = [ "us-east-2a" ]
}

resource "null_resource" "copy_kubconfig_to_destination" {
  provisioner "local-exec" {
    when = create
    on_failure = fail

    command = <<-EOC

      cp ${path.module}/.terraform/modules/self_managed_k8s_cluster/outputs/kubeconfig.yaml ../kubernetes

    EOC
  }
}