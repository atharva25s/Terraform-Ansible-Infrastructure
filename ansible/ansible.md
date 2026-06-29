# Terraform and Ansible Deployment Guide

## Step 1: Navigate to the Terraform Directory

```bash
cd /home/ubuntu/terraform
```

You should find the following files:

```text
provider.tf
main.tf
```

---

## Step 2: Verify the Ansible Inventory Path

Open `main.tf` and ensure that the path where `inventory.ini` is generated is:

```text
/home/ubuntu/ansible
```

If the path is different, update it before proceeding.

---

## Step 3: Configure AWS Credentials

Open `provider.tf` and replace the placeholder values with your AWS credentials.

```terraform
provider "aws" {
  region     = "ap-south-1"
  access_key = "your_access_key_here"
  secret_key = "your_secret_key_here"
}
```

---

#  Terraform Commands

Run the following commands **in order** from `/home/ubuntu/terraform`.

### 1. Initialize Terraform

```bash
terraform init
```

### 2. Review the Execution Plan

```bash
terraform plan
```

### 3. Provision the Infrastructure

```bash
terraform apply
```

When prompted, type:

```text
yes
```

---

## Step 4: Navigate to the Ansible Directory

```bash
cd /home/ubuntu/ansible
```

You should see the following files:

```text
inventory.ini
site.yml
```

---

#  Ansible Command

Run the following command to configure all provisioned instances:

```bash
ansible-playbook -i inventory.ini site.yml
```

---

## Commands Summary

> Run these commands **in this exact order**:

```bash
cd /home/ubuntu/terraform

terraform init

terraform plan

terraform apply

cd /home/ubuntu/ansible

ansible-playbook -i inventory.ini site.yml
```
