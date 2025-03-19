# Opsfleet-AWS_EKS_Karpenter

terraform-eks-karpenter/
├── README.md
├── main.tf
├── variables.tf
├── outputs.tf
├── providers.tf
├── modules/
│   ├── eks/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   ├── karpenter/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
└── environments/
    ├── dev/
    │   ├── main.tf
    │   ├── variables.tf
    │   ├── outputs.tf


# Terraform EKS + Karpenter Setup

This repository contains Terraform configurations for deploying an **Amazon EKS cluster** with **Karpenter** for node auto-scaling.

## Setup Instructions

### **Initialize Terraform**
Ensure you have **Terraform** installed, then run:
```sh
terraform init
```
### **Validate and Plan**
```sh
terraform plan
```
### **Deploy the Infrastructure**
```sh
terraform apply -auto-approve
```
### **This will:**

Create an EKS Cluster (K8s-Opsfleet).
Set up IAM roles for Karpenter.
Deploy Karpenter for automatic provisioning of nodes.

### **Configure kubectl**
Once the cluster is deployed, update your kubeconfig:
```sh
aws eks update-kubeconfig --region us-west-2 --name <your-cluster-name>
```
### **Test the connection:**
```sh
kubectl get nodes
```

## Running a Pod on x86 or Graviton (ARM)

### **You can run workloads on either x86 (m5.large) or Graviton (m6g.large) instances using Karpenter.**

### **Deploy a Sample Pod on x86 (amd64)**
```sh
apiVersion: v1
kind: Pod
metadata:
  name: x86-pod
spec:
  nodeSelector:
    kubernetes.io/arch: amd64
  containers:
  - name: nginx
    image: nginx:latest
```
### **Apply the manifest:**
```sh
kubectl apply -f x86-pod.yaml
```

### **Deploy a Sample Pod on Graviton (arm64)**
```sh
apiVersion: v1
kind: Pod
metadata:
  name: arm64-pod
spec:
  nodeSelector:
    kubernetes.io/arch: arm64
  containers:
  - name: nginx
    image: nginx:latest
```
### **Apply the manifest:**
```sh
kubectl apply -f arm64-pod.yaml
```

### **Check if nodes are provisioned by Karpenter:**
```sh
kubectl get nodes
```
## Destroying the Infrastructure

### **To delete everything:**
```sh
terraform destroy -auto-approve
```

## Test Spot Instance Deployment

### **Deploy a sample pod that prefers a Spot instance:**

```bash
apiVersion: v1
kind: Pod
metadata:
  name: spot-test-pod
spec:
  nodeSelector:
    karpenter.k8s.aws/instance-lifecycle: spot
  containers:
  - name: busybox
    image: busybox
    command: ["sleep", "3600"]
```

### **Apply the manifest:**
```bash
kubectl apply -f spot-test-pod.yaml
```

### **Check if it runs on a Spot instance:**
```bash
kubectl get nodes -o wide
```

### **Look for karpenter.k8s.aws/instance-lifecycle=spot in the node labels.**

## Benefits of This Setup

- Reduces EC2 costs by up to 90% using Spot instances
- Automatically falls back to On-Demand instances if Spot instances are unavailable
- Supports mixed instance types (x86 & ARM64) for flexibility
- Easily configurable via Karpenter Provisioner