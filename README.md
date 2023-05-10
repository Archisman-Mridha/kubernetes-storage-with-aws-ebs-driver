# Kubernetes Storage with AWS EBS driver

Demonstrating how to use AWS EBS as the storage driver with Kubernetes.

> **Aim - Create a local Kubernetes cluster using K3D. Use AWS EBS as the underlying storage provider. Create StorageClasses for dynamic provisioning of PVCs. Deploy a stateful application which will claim storage and use that for data storage.**

## Procedure

- Spin up a local K3D cluster using the command `make create-cluster` from the workspace root.

- Create an AWS IAM user representing the AWS EBS CSI driver. To this IAM user, attach the AWS managed IAM policy `arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy`. Then create and save an AWS key-pair for this IAM user.
  I have done this using Terraform. The AWS key-pair is saved at **./terraform/outputs/ebs-csi-driver.aws-keys** after `terraform apply` is executed successfully.

- Create a Kubernetes secret using this command -
  ```bash
    kubectl create secret generic aws-secret \
    --namespace kube-system \
    --from-literal "key_id=${AWS_ACCESS_KEY_ID}" \
    --from-literal "access_key=${AWS_SECRET_ACCESS_KEY}"
  ```

## References

- https://github.com/kubernetes-sigs/aws-ebs-csi-driver
