# Dockerfile for a multi-arch image (ARM64 and AMD64) on Apple Silicon (M1/M2/M3)
#
# Base image is Alpine, which is lightweight and supports ARM64 natively.
FROM alpine:latest
# Metadata
LABEL maintainer="Jirka Pech <git@pech.cz>"

# Install essential packages:
# bash - for a better shell experience
# mc - Midnight Commander
# openssh-server & openssh-client - for SSH connectivity
RUN apk add --no-cache openssh openssh-client nginx bash mc

# --- SSH Server Configuration (Key-Based Login) ---

# Generate SSH Host Keys (required for the SSH server to start)
RUN ssh-keygen -A

COPY sshd_config /etc/ssh/sshd_config
COPY authorized_keys /root/.ssh/authorized_keys

RUN chown -R root:root /root

# Expose the SSH port
EXPOSE 22

# Start the SSH daemon (sshd) in the foreground.
# This keeps the container running continuously.
CMD ["/usr/sbin/sshd", "-D"]
