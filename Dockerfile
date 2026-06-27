# =============================================================================
# Stage 1 — builder
# Downloads and verifies the Terraform binary so the runtime stage stays clean.
# =============================================================================
FROM ubuntu:22.04 AS builder

# Terraform version to pin (change here to upgrade)
ARG TERRAFORM_VERSION=1.8.5
ARG TARGETARCH=amd64

# Install only what's needed to fetch and verify Terraform
RUN apt-get update && apt-get install -y --no-install-recommends \
        curl \
        gnupg \
        unzip \
    && rm -rf /var/lib/apt/lists/*

# Import HashiCorp's GPG key and verify the downloaded binary
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

# Download Terraform zip + checksum file, then verify
RUN curl -fsSL "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_${TARGETARCH}.zip" \
         -o /tmp/terraform.zip \
    && curl -fsSL "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_SHA256SUMS" \
         -o /tmp/terraform_SHA256SUMS \
    && grep "terraform_${TERRAFORM_VERSION}_linux_${TARGETARCH}.zip" /tmp/terraform_SHA256SUMS | sha256sum -c - \
    && unzip /tmp/terraform.zip -d /usr/local/bin/ \
    && chmod +x /usr/local/bin/terraform \
    && rm -f /tmp/terraform.zip /tmp/terraform_SHA256SUMS


# =============================================================================
# Stage 2 — runtime
# Minimal image with Terraform (from builder) + Ansible + repo configs.
# =============================================================================
FROM ubuntu:22.04

LABEL maintainer="atharva25s" \
      description="Terraform + Ansible IaC toolkit"

# Avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install Ansible (via PPA) and runtime dependencies in a single layer.
# python3-boto3 / python3-botocore are included for AWS dynamic inventory.
RUN apt-get update && apt-get install -y --no-install-recommends \
        software-properties-common \
        gnupg \
        curl \
        git \
        openssh-client \
        python3 \
        python3-pip \
        python3-boto3 \
        python3-botocore \
    && add-apt-repository --yes ppa:ansible/ansible \
    && apt-get update && apt-get install -y --no-install-recommends \
        ansible \
    # Clean up apt caches to keep the layer small
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Copy the verified Terraform binary from the builder stage
COPY --from=builder /usr/local/bin/terraform /usr/local/bin/terraform

# Set working directory
WORKDIR /workspace

# Copy Terraform and Ansible configuration files from the repo
COPY terraform/ ./terraform/
COPY ansible/  ./ansible/

# Initialise Terraform providers at build time so the image is self-contained
# (remove this block if you prefer to run `terraform init` at runtime instead)
RUN cd /workspace/terraform && terraform init -input=false || true

# Expose a sensible PATH and default shell
ENV PATH="/usr/local/bin:${PATH}"

# Default: drop into bash so users can run terraform / ansible-playbook interactively.
# Override with `docker run ... terraform plan` or `ansible-playbook ...` as needed.
CMD ["bash"]