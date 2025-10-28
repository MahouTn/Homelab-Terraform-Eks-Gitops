# Homelab: Terraform + EKS + Jenkins + FluxCD + Datadog

![AWS](https://img.shields.io/badge/AWS-EKS-blue?logo=amazon-aws&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-Cloud-blue?logo=terraform&logoColor=white)
![Kubernetes](https://img.shields.io/badge/Kubernetes-cluster-blue?logo=kubernetes&logoColor=white)
![Jenkins](https://img.shields.io/badge/Jenkins-CI-orange?logo=jenkins&logoColor=white)
![FluxCD](https://img.shields.io/badge/FluxCD-GitOps-blue?logo=fluxcd&logoColor=white)
![Datadog](https://img.shields.io/badge/Datadog-Monitoring-blue?logo=datadog&logoColor=white)

> A personal homelab setup to learn cloud infrastructure, CI/CD, and GitOps in a real-world scenario.

Here’s a breakdown of the architecture:

![EKS Architecture](https://i.imgur.com/A64bFWd.png) 

---

## Repository Structure
```
eks-aws/
├── Terraform-files/       # Infrastructure as Code (EKS, VPC, IAM roles)
├── k8s/
│   ├── application/       # Demo app manifests
│   ├── jenkins/           # Jenkins deployment manifests or Helm charts
│   └── datadog/           # Datadog agent deployment manifests
├── clusters/eks           # GitOps configuration for FluxCD
├── app-code/              # Demo applications for CI/CD pipelines
└── .gitignore
```

## Goals

1. Use **Terraform** to provision AWS EKS clusters.  
2. Deploy **Jenkins** in Kubernetes for CI/CD pipelines.  
3. Connect **Jenkins** pipelines to **GitHub**.  
4. Deploy demo applications manually and via Jenkins.  
5. Implement **FluxCD GitOps workflow** for automated deployments.  
6. Monitor cluster and applications with **Datadog**.



## Project Overview

* **VPC:** 4 subnets (2 public, 2 private) with per-AZ NAT Gateways.
* **EKS Cluster:** Public control plane endpoint with worker nodes (t3.medium managed node group) in private subnets.
* **Security:** Implemented EKS control-plane ↔ nodes SGs, plus **OIDC + IRSA** for the EBS CSI driver.
* **Terraform State:** Managed securely in **S3 with DynamoDB locks**.

After provisioning, I deployed a **Node.js app** via Helm. The CI/CD flow is:
**Jenkins** builds the Docker image with Kaniko, pushes it to ECR, and automatically updates Helm values with the new image tag. This then triggers **FluxCD** for the final auto deployment. ✅

With Jenkins + FluxCD, we now have a full GitOps-driven CI/CD pipeline!
