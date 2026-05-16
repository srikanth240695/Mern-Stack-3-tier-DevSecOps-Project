resource "aws_eks_cluster" "main" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = var.kubernetes_version

  vpc_config {
    subnet_ids              = concat(var.public_subnet_ids, var.private_subnet_ids)
    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access  = var.endpoint_public_access
    security_group_ids      = [var.eks_cluster_security_group_id]
  }

  access_config {
    authentication_mode                         = "API_AND_CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = true
  }

  tags = {
    Name        = var.cluster_name
    Environment = var.environment
  }

  depends_on = [aws_iam_role_policy_attachment.eks_cluster_policy]
}

resource "aws_iam_openid_connect_provider" "eks_oidc_provider" {
  url             = aws_eks_cluster.main.identity[0].oidc[0].issuer
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks_certificate.certificates[0].sha1_fingerprint]
}

resource "aws_eks_addon" "eks_addon" {
  cluster_name = aws_eks_cluster.main.name
  for_each     = { for addon in var.addons : addon.name => addon }
  addon_name   = each.value.name

  service_account_role_arn = each.value.name == "aws-ebs-csi-driver" ? aws_iam_role.ebs_csi_role.arn : null

  tags = {
    Name        = "${var.cluster_name}-${each.value.name}-addon"
    Environment = var.environment
  }

  depends_on = [aws_eks_node_group.ondemand-nodegroup, aws_eks_node_group.spot-nodegroup]

}

resource "aws_eks_node_group" "ondemand-nodegroup" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${var.cluster_name}-node-group"
  node_role_arn   = aws_iam_role.eks_nodegroup_role.arn
  subnet_ids      = var.private_subnet_ids

  scaling_config {
    desired_size = var.desired_size_ondemand
    max_size     = var.maximum_size_ondemand
    min_size     = var.minimum_size_ondemand
  }

  instance_types = var.ondemand_instance_types
  capacity_type  = "ON_DEMAND"
  disk_size      = 20
  labels = {
    type = "ondemand"
  }

  update_config {
    max_unavailable = 1
  }

  tags = {
    Name        = "${var.cluster_name}-node-group"
    Environment = var.environment
  }

  depends_on = [aws_eks_cluster.main, aws_iam_role_policy_attachment.eks_nodegroup_policy]

}

resource "aws_eks_node_group" "spot-nodegroup" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${var.cluster_name}-spot-node-group"
  node_role_arn   = aws_iam_role.eks_nodegroup_role.arn
  subnet_ids      = var.private_subnet_ids

  scaling_config {
    desired_size = var.desired_size_spot
    max_size     = var.maximum_size_spot
    min_size     = var.minimum_size_spot
  }

  instance_types = var.spot_instance_types
  capacity_type  = "SPOT"
  disk_size      = 20

  labels = {
    type      = "spot"
    lifecycle = "spot"
  }

  update_config {
    max_unavailable = 1
  }

  tags = {
    Name        = "${var.cluster_name}-spot-node-group"
    Environment = var.environment
  }

  depends_on = [aws_eks_cluster.main, aws_iam_role_policy_attachment.eks_nodegroup_policy]

}