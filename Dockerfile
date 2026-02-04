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

# Create and set working directory
RUN mkdir -p /opencode-home
WORKDIR /opencode-home

# Create startup script
RUN echo '#!/bin/sh' > /start.sh \
    && echo 'if [ -n "$SSH_PUBLIC_KEY" ]; then' >> /start.sh \
    && echo '    echo "$SSH_PUBLIC_KEY" > /root/.ssh/authorized_keys' >> /start.sh \
    && echo '    chmod 600 /root/.ssh/authorized_keys' >> /start.sh \
    && echo 'fi' >> /start.sh \
    && echo '/usr/sbin/sshd' >> /start.sh \
    && echo 'exec opencode web --hostname 0.0.0.0 --port 3000' >> /start.sh \
    && chmod +x /start.sh


# Expose ports
EXPOSE 2222 3000

ENTRYPOINT ["/bin/sh"]
CMD ["/start.sh"]