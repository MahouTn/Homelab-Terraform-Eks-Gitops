resource "aws_security_group" "cluster" {
  name        = "homelab-eks-cluster-sg"
  description = "security group for the eks cluster"
  vpc_id      = var.vpc_id

  tags = {
    Name = "homelab-eks-cluster-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_https" {
  security_group_id = aws_security_group.cluster.id
  cidr_ipv4         = var.internet
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_egress_rule" "cluster_to_node_outbound" {
  security_group_id            = aws_security_group.cluster.id
  description                  = "Allow Control Plane to reach the Nodes"
  ip_protocol                  = "tcp"
  from_port                    = 1025
  to_port                      = 65535
  referenced_security_group_id = aws_security_group.node.id
}

resource "aws_security_group" "node" {
  name        = "homelab-eks-node-sg"
  description = "security group for the node group"
  vpc_id      = var.vpc_id

  tags = {
    Name = "homelab-eks-node-sg"
    # 💥 CRITICAL: EKS requires this tag to identify the worker node SG.
    # Assuming 'aws_eks_cluster.main.name' is available as a variable/input in the module
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

# Nodes need to talk to the EKS API (443) and other services (ECR, S3, etc.)
resource "aws_vpc_security_group_egress_rule" "node_all_egress" {
  security_group_id = aws_security_group.node.id
  cidr_ipv4         = var.internet # Allow outbound to all destinations
  ip_protocol       = "-1"
}

# --- Node Group Ingress Rules (CRITICAL for Cluster Function) ---

# Rule 1: Allow Nodes to talk to the EKS Control Plane (API Server)
resource "aws_vpc_security_group_ingress_rule" "node_to_cluster_api" {
  security_group_id            = aws_security_group.node.id
  description                  = "Allow Nodes to communicate with EKS Control Plane"
  from_port                    = 443
  to_port                      = 443
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.cluster.id
}

# Rule 2: Allow Pod-to-Pod and Node-to-Node communication (via CNI)
resource "aws_vpc_security_group_ingress_rule" "node_to_node_traffic" {
  security_group_id            = aws_security_group.node.id
  description                  = "Allow Node to Node/Pod to Pod traffic (all protocols)"
  ip_protocol                  = "-1"
  referenced_security_group_id = aws_security_group.node.id
}

# Rule 3: Allow the EKS Control Plane to talk to the Nodes (for ENI/Pod management)
resource "aws_vpc_security_group_ingress_rule" "cluster_to_node_kubelet" {
  security_group_id            = aws_security_group.node.id
  description                  = "Allow Control Plane to communicate with Kubelet and ENIs"
  from_port                    = 1025 # Low end of ephemeral ports
  to_port                      = 65535
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.cluster.id
}