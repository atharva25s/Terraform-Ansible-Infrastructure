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

## Step 4: Initialize Terraform

```bash
terraform init
```

---

## Step 5: Review the Execution Plan

```bash
terraform plan
```

---

## Step 6: Provision the Infrastructure

```bash
terraform apply
```

When prompted, type:

```text
yes
```

Wait for Terraform to finish provisioning the infrastructure.

---

## Step 7: Navigate to the Ansible Directory

```bash
cd /home/ubuntu/ansible
```

You should see the following files:

```text
inventory.ini
site.yml
```

---

## Step 8: Run the Ansible Playbook

Execute the following command:

```bash
ansible-playbook -i inventory.ini site.yml
```

Once the playbook completes successfully, the infrastructure will be configured and ready to use.
