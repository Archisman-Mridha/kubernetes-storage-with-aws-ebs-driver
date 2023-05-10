resource "aws_iam_user" "ebs_csi_driver" {
  name = "ebs-csi-driver"
  path = "/projects/${var.project_name}/"
}

resource "aws_iam_user_policy_attachment" "ebs_csi_driver" {
  user       = aws_iam_user.ebs_csi_driver.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

resource "aws_iam_access_key" "ebs_csi_driver" {
  user = aws_iam_user.ebs_csi_driver.name
}

resource "null_resource" "output_ebs_csi_driver_aws_keys" {
  provisioner "local-exec" {
    when       = create
    on_failure = fail

    command = <<-EOC

      rm -f ./outputs/ebs-csi-driver.aws-keys

      mkdir -p ./outputs
      touch ./outputs/ebs-csi-driver.aws-keys

      tee -a ./outputs/ebs-csi-driver.aws-keys <<-EOF
        aws_access_key = ${aws_iam_access_key.ebs_csi_driver.id}
        aws_secret_key = ${aws_iam_access_key.ebs_csi_driver.secret}
      EOF

    EOC
  }
}
