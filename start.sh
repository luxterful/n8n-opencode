#!/bin/sh
if [ -n "$SSH_PUBLIC_KEY" ]; then
    echo "$SSH_PUBLIC_KEY" | tr ',' '\n' > /root/.ssh/authorized_keys
    chmod 600 /root/.ssh/authorized_keys
fi
if [ -z "$(ls -A ./home)" ]; then
  cp -r ./home-template/* /home/
fi
/usr/sbin/sshd
exec opencode web --hostname 0.0.0.0 --port 3000
