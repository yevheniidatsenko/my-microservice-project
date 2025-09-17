# CI/CD Pipeline with Jenkins, Terraform, Helm, and Argo CD

## Overview

This project demonstrates a full CI/CD pipeline integrating Jenkins, Terraform, Helm, and Argo CD on AWS.

The pipeline automates:

- Building Docker images for a Django application with Jenkins
- Pushing built images to Amazon ECR
- Updating Helm chart with new image tags in a Git repository
- Deploying and synchronizing the application on an Amazon EKS cluster via Argo CD

This practical task shows modern DevOps workflows for rapid, reliable, and repeatable production deployments.

***

## How to Apply Terraform

1. Clone the repository and switch to branch `lesson-8-9`:

```bash
git clone <repository-url>
cd <project-folder>
git checkout lesson-8-9
```

2. Initialize Terraform and apply the configuration:

```bash
terraform init
terraform apply
```

> **Important:** Remember to destroy resources when done to avoid unwanted AWS costs:

```bash
terraform destroy
```

***

## How to Check Jenkins Job

1. Access Jenkins UI (URL and admin password output by Terraform module).

2. Locate and run the pipeline job that performs:

   - Building Docker image using Kaniko
   - Pushing image to ECR
   - Updating Helm charts with new image tag
   - Pushing updated Helm chart to Git repo

3. Monitor stages and logs for successful execution.

***

## How to See Results in Argo CD

1. Access Argo CD UI (URL and initial admin password output by Terraform).

2. Check that the Application is synced and healthy.

3. Confirm that new pods are running in the EKS cluster:

```bash
kubectl -n <app-namespace> get pods
```

4. Verify your Django application is working as expected.

***

## Project Structure

```
- `assets/` — images and resources for documentation  
- `backend.tf` — Terraform backend configuration (S3 + DynamoDB)  
- `charts/django-app/` — Helm chart for Django application  
- `django-docker-project/` — Django application source code with nginx and static files  
- `Jenkinsfile` — Jenkins pipeline configuration  
- `main.tf` — main Terraform file to connect modules  
- `modules/` — Terraform modules for different services:
  - `argo_cd/` — Argo CD installation via Helm
  - `ecr/` — ECR repository creation
  - `eks/` — EKS cluster setup
  - `jenkins/` — Jenkins installation via Helm
  - `s3-backend/` — S3 and DynamoDB for Terraform state
  - `vpc/` — VPC setup, subnets, routing  
- `outputs.tf` — Terraform resource outputs  
- `README.md` — project documentation  
- `variables.tf` — Terraform variables   
```

***

## Notes

- Automate migrations inside CI/CD or Kubernetes to avoid DB schema issues.
- Scale EKS nodes and allocate resources appropriately.
- Clean up all created AWS resources after testing to minimize costs.
- Use Terraform output commands for quick resource info.

## Results

![SCR](./assets/SCR_1.png)
![SCR](./assets/SCR_2.png)
![SCR](./assets/SCR_3.png)
![SCR](./assets/SCR_4.png)