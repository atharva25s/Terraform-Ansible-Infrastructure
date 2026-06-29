# =============================================================================
# Single-stage image — ubuntu:22.04 (jammy)
#
# Terraform is installed from the official HashiCorp apt repository.
# Ansible is installed from the official Ansible PPA.
# Both avoid direct binary downloads, which are blocked in many build envs.
# =============================================================================
FROM ubuntu:22.04

LABEL maintainer="atharva25s" \
      description="Terraform + Ansible IaC toolkit"

# Avoid interactive prompts during apt installs
ENV DEBIAN_FRONTEND=noninteractive

# -----------------------------------------------------------------------------
# 1. Base dependencies + HashiCorp apt repo + Ansible PPA
#    Combining into as few RUN layers as possible for better caching.
# -----------------------------------------------------------------------------
RUN apt-get update && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        gnupg \
        lsb-release \
        software-properties-common \
        git \
        openssh-client \
        openssh-server \
        python3 \
        python3-pip \
        python3-boto3 \
        python3-botocore \
    && rm -rf /var/lib/apt/lists/*

# -----------------------------------------------------------------------------
# 2. Add HashiCorp apt repository for Terraform
# -----------------------------------------------------------------------------
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg \
        | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
        https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
        > /etc/apt/sources.list.d/hashicorp.list

# -----------------------------------------------------------------------------
# 3. Add Ansible PPA
# -----------------------------------------------------------------------------
RUN add-apt-repository --yes ppa:ansible/ansible

# -----------------------------------------------------------------------------
# 4. Install Terraform + Ansible from their respective repos in one apt pass.
#    Pinning Terraform version avoids surprise upgrades.
#    Clean up apt cache immediately to keep the layer small.
# -----------------------------------------------------------------------------
ARG TERRAFORM_VERSION=1.8.5
RUN apt-get update && apt-get install -y --no-install-recommends \
        terraform=${TERRAFORM_VERSION}-* \
        ansible \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Smoke-test both tools are reachable
RUN terraform version && ansible --version

# -----------------------------------------------------------------------------
# 5. Copy repo configs into the image
# -----------------------------------------------------------------------------
WORKDIR /home/ubuntu

COPY terraform/ ./terraform/
COPY ansible/   ./ansible/

# Initialise Terraform providers at build time (optional — remove if provider
# credentials are not available during the build).
RUN cd /home/ubuntu/terraform && terraform init -input=false || true \
    && mkdir -p /home/ubuntu/config \
    && touch /home/ubuntu/config/test-key.pem \
    && chmod 600 /home/ubuntu/config/test-key.pem

# -----------------------------------------------------------------------------
# Default entrypoint: interactive shell.
# Override at runtime:
#   docker run --rm -it <image> terraform plan
#   docker run --rm -it <image> ansible-playbook ansible/site.yml
# -----------------------------------------------------------------------------
CMD ["bash"]