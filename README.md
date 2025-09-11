# Django + PostgreSQL on Kubernetes with Helm & Terraform

## Project Overview
This project demonstrates deploying a Django application connected to PostgreSQL on a Kubernetes cluster managed via Terraform and Helm. The app is containerized with Docker, images are hosted in Amazon ECR, and Kubernetes cluster autoscaling is configured.

---

## Architecture
- Kubernetes cluster created by Terraform in existing VPC.
- Amazon ECR stores Docker images.
- Django app deployed via Helm chart with:
  - Deployment using image from ECR.
  - LoadBalancer service for external access.
  - ConfigMap for environment variables.
  - Horizontal Pod Autoscaler (HPA) scaling pods between 2-6 replicas based on CPU usage.

---

## Prerequisites
- AWS account with Terraform configured.
- kubectl and Helm installed locally.
- Docker installed to build images.
- AWS CLI configured for authentication with ECR.

---

## Setup and Deployment Instructions

### 1. Create AWS Infrastructure
Apply Terraform scripts under `lesson-7/modules/` to create:
- Kubernetes cluster (EKS) in appropriate VPC subnet.
- ECR repository for Docker images.

### 2. Build and Push Docker Image
Build image with platform linux/amd64 support and push to ECR:

```
docker buildx build --platform linux/amd64 -t lesson-5-ecr:v1.0.16 --load .
docker tag lesson-5-ecr:v1.0.16 <aws_account_id>.dkr.ecr.<region>.amazonaws.com/lesson-5-ecr:v1.0.16
aws ecr get-login-password --region <region> | docker login --username AWS --password-stdin <aws_account_id>.dkr.ecr.<region>.amazonaws.com
docker push <aws_account_id>.dkr.ecr.<region>.amazonaws.com/lesson-5-ecr:v1.0.16
```

### 3. Configure Helm Chart Values
Edit `charts/django-app/values.yaml`:

```
image:
  repository: <aws_account_id>.dkr.ecr.<region>.amazonaws.com/lesson-5-ecr
  tag: v1.0.16
  pullPolicy: Always

config:
  DB_HOST: "postgres-service"
  DB_PORT: "5432"
  POSTGRES_USER: "postgres"
  POSTGRES_PASSWORD: "postgres"
  POSTGRES_DB: "myproject"

service:
  type: LoadBalancer
  port: 80

autoscaling:
  enabled: true
  minReplicas: 2
  maxReplicas: 6
  targetCPUUtilizationPercentage: 70
```

### 4. Deploy Application with Helm

```
helm upgrade django-app ./charts/django-app -f ./charts/django-app/values.yaml
kubectl rollout restart deployment django-app
```

### 5. Run Database Migrations

Run migrations to create necessary tables:

```
kubectl run django-migrate --rm -it --restart=Never \
  --image=<aws_account_id>.dkr.ecr.<region>.amazonaws.com/lesson-5-ecr:v1.0.16 \
  --env="DB_HOST=postgres-service" \
  --env="DB_PORT=5432" \
  --env="POSTGRES_USER=postgres" \
  --env="POSTGRES_PASSWORD=postgres" \
  --env="POSTGRES_DB=myproject" \
  -- python manage.py migrate
```

---

## Verification

- Pods status: `kubectl get pods` shows all running with no restarts.
- Accessible app via LoadBalancer IP.
- Health check endpoint `/health/` returns success.
- Auto-scaling scales pods based on CPU load (2-6 replicas as configured).

# Project Execution: Screenshots and Results

![SCR](assets/SCR_1.png)
![SCR](assets/SCR_2.png)
![SCR](assets/SCR_3.png)
![SCR](assets/SCR_4.png)