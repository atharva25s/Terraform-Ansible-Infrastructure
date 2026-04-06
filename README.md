# Terraform Setup Guide

## 1. Install Terraform

```bash
# Update packages
sudo apt update && sudo apt upgrade -y

# Install required dependencies
sudo apt install -y gnupg software-properties-common curl

# Add HashiCorp GPG key
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -

# Add official HashiCorp repository
sudo apt-add-repository "deb https://apt.releases.hashicorp.com $(lsb_release -cs) main"

# Install Terraform
sudo apt update && sudo apt install -y terraform

# Verify installation
terraform -version
```

---

## 2. Create Terraform Directory

```bash
mkdir -p ~/terraform
cd ~/terraform
```

---

## 3. Clone Repository

```bash
git clone https://github.com/<your-repo>/KinD-deployment-with-ArgoCD.git
```

---

## 4. Copy Terraform Configuration

Navigate and copy the Terraform folder:

```bash
cp -r KinD-deployment-with-ArgoCD/infrastructure/terraform/* ~/terraform/
```

---

## 5. Verify Directory Structure

Ensure your local Terraform directory looks like this:

```
~/terraform/
├── main.tf
├── variables.tf
├── outputs.tf
└── ...
```

