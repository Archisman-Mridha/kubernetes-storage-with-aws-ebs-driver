# Kubernetes Storage with AWS EBS driver

Demonstrating how to use AWS EBS as the storage driver with Kubernetes.

> Aim - Create a self-managed Kubernetes cluster in AWS. Use AWS EBS as the underlying storage provider. Create StorageClasses for dynamic provisioning of PVCs. Deploy a stateful application which will claim some PV.

## Procedure

- Bootstrap a self=managed Kubernetes cluster in AWS using Terraform. Make sure when bootstrapping the cluster, you set `--allow-privileged=true` for the Kubernetes API server.
  Execute this command to set the path to the kubeconfig file -

```bash
export KUBECONFIG=${path.module}/../kubernetes/kubeconfig.yaml
```

- Create an AWS IAM user representing the AWS EBS CSI driver. To this IAM user, attach the AWS managed IAM policy `arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy`. Then create and save an AWS key-pair for this IAM user.
  The AWS key-pair is saved at **./terraform/outputs/ebs-csi-driver.aws-keys** after `terraform apply` is executed successfully.

- Create a Kubernetes secret using this command -

  ```bash
  kubectl create secret generic aws-secret \
    --namespace kube-system \
    --from-literal "key_id=${AWS_ACCESS_KEY_ID}" \
    --from-literal "access_key=${AWS_SECRET_ACCESS_KEY}"
  ```

- Deploy the AWS EBS CSI driver using Helm -

  ```bash
  helm repo add aws-ebs-csi-driver https://kubernetes-sigs.github.io/aws-ebs-csi-driver &&
    helm repo update
  helm upgrade --install aws-ebs-csi-driver \
    --namespace kube-system \
    aws-ebs-csi-driver/aws-ebs-csi-driver

  # Verify that the pods are running
  kubectl get pods -n kube-system -l app.kubernetes.io/name=aws-ebs-csi-driver
  ```

- Create the Storageclass and PVC -

  ```bash
  kubectl apply -f ./kubernetes/manifests
  ```

  You will see the PV automatically getting created.

## References

- https://github.com/kubernetes-sigs/aws-ebs-csi-driver
