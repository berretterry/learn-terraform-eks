output "cluster_id" {
    description = "EKS cluster ID"
    value = module.eks.cluster_id
}

output "cluster_endpoint" {
    description = "endpoint for eks control plane"
    value = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
    description = "security group ids attached to the cluster control plane"
    value = module.eks.cluster_security_group_id
}

output "AWS_REGION" {
    description = "AWS region"
    value = var.AWS_REGION
}

output "cluster_name" {
    description = "K8 cluster name"
    value = local.cluster_name
}