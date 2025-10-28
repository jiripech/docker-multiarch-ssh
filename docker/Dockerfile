# Dockerfile for a multi-arch image (ARM64 and AMD64) on Apple Silicon (M1/M2/M3)
#
# Base image is Alpine, which is lightweight and supports ARM64 natively.
FROM alpine:latest

# Define ARG to accept the SSH Public Key during build.
# NOTE: ARG values are visible in image history, so be cautious with sensitive data.
ARG SSH_PUB_KEY

# Install essential packages:
# bash - for a better shell experience
# mc - Midnight Commander
# openssh-server & openssh-client - for SSH connectivity
RUN apk update && \
    apk add --no-cache bash openssh-server openssh-client mc && \
    # Clean up the cache after installation
    rm -rf /var/cache/apk/*

# --- SSH Server Configuration (Key-Based Login) ---

# 1. Generate SSH Host Keys (required for the SSH server to start)
RUN ssh-keygen -A

# 2. Setup authorized_keys for root using the passed ARG
# This step creates the .ssh directory and authorized_keys file with the public key.
RUN if [ -n "$SSH_PUB_KEY" ]; then \
        mkdir -p /root/.ssh && \
        echo "$SSH_PUB_KEY" > /root/.ssh/authorized_keys && \
        chmod 700 /root/.ssh && \
        chmod 600 /root/.ssh/authorized_keys && \
        # Ensure root owns the files
        chown -R root:root /root/.ssh; \
    else \
        echo "WARNING: SSH_PUB_KEY ARG was not provided. Key-based login will not work."; \
    fi

# 3. Configure SSH Daemon: 
# Explicitly allow root login ONLY with keys and disable password authentication entirely for security.
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin without-password/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config

# Expose the SSH port
EXPOSE 22

# Start the SSH daemon (sshd) in the foreground.
# This keeps the container running continuously.
CMD ["/usr/sbin/sshd", "-D"]
