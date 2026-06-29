# Terraform-Ansible Setup Guide

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

## 2. Install Ansible

```bash
sudo apt install ansible
```

## 3. Install Git
```bash
sudo apt install git
```

## 4. Clone Repository

```bash
git clone https://github.com/atharva25s/Terraform-Ansible-Infrastructure.git
```

---

## 5. Create Terraform and Ansible Directory

```bash
mkdir -p ~/terraform
mkdir -p ~/ansible
```

---



## 4. Copy the Configurations


```bash
cp -r ~/Terraform-Ansible-Infrastructure/terraform/* ~/terraform/
```
```bash
cp -r ~/Terraform-Ansible-Infrastructure/ansible/* ~/ansible/
```
---

## 5. Verify Directory Structure

- local Ansible directory looks like this:

```
~/ansible/
├── group_vars/
├── roles/
├── site.yml
└── ...
```
- local Terraform directory looks like this:

```
~/terraform/
├── main.tf
├── provider.tf
└── ...
```


## 6. Just Simply run the docker container
```bash
docker run -itd --name deployment-server -p 2222:22 atharva25s/terraform-ansible-setup:v2
```
- Follow [Next steps](ansible/ansible.md)