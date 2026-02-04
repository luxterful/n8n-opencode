FROM ghcr.io/anomalyco/opencode

# Install OpenSSH server
RUN apk add --no-cache openssh

# Configure SSH
RUN mkdir -p /var/run/sshd \
    && ssh-keygen -A \
    && sed -i 's/#Port 22/Port 2222/' /etc/ssh/sshd_config \
    && sed -i 's/#PermitRootLogin.*/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config \
    && sed -i 's/#PubkeyAuthentication.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config \
    && sed -i 's/#PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config \
    && sed -i 's/#AuthorizedKeysFile.*/AuthorizedKeysFile .ssh\/authorized_keys/' /etc/ssh/sshd_config

# Create .ssh directory for root user
RUN mkdir -p /root/.ssh && chmod 700 /root/.ssh

# Copy home folder contents to /root/home
COPY ./home /root/home-template
RUN mkdir -p /root/home
WORKDIR /root/home

# Set opencode config directory
ENV OPENCODE_CONFIG_DIR=/root/home/.config

# Copy startup script
COPY start.sh /root/start.sh
RUN chmod +x /root/start.sh

COPY run.sh /root/run.sh
RUN chmod +x /root/run.sh

# Expose ports
EXPOSE 2222 3000

WORKDIR /root/home
ENTRYPOINT ["/bin/sh"]
CMD ["/root/start.sh"]