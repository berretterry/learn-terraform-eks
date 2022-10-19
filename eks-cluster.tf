module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "11.0.0"
  # insert the 4 required variables here

  cluster_name = local.cluter_name
  cluster_version = "1.22"

  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"

    attach_cluster_primary_security_group = true

    create_security_group = false
  }

  eks_managed_node_groups = {
    one = {
        name = "node-group-1"

        instance_types = ["t3.small"]

        min_size = 1
        max_size = 3
        desired_size = 2

        pre_bootstrap_user_data = <<-EOT
        echo 'foo bar'
        EOT

        vpc_security_group_ids = [
            aws_security_group.node_group.one.id
        ]
    }

    two = {
        name = "node-group-2"
    }
  }

}