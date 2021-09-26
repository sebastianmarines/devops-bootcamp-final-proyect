FROM robertdebock/docker-centos-openssh:latest

COPY ./keys/id_rsa.pub /root/.ssh/authorized_keys

RUN dnf makecache \
    && dnf install -y sudo

EXPOSE 2222

