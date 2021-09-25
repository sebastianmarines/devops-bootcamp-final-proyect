FROM robertdebock/docker-centos-openssh:latest

COPY ./keys/id_rsa /root/.ssh/id_rsa

RUN chmod 400 /root/.ssh/id_rsa

RUN dnf makecache \
    && dnf install -y epel-release \
    && dnf makecache \
    && dnf install -y ansible

COPY ./control-entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

RUN echo "host" > /etc/ansible/hosts
