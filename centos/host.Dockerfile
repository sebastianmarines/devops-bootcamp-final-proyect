FROM robertdebock/docker-centos-openssh:latest

COPY ./keys/id_rsa.pub /root/.ssh/authorized_keys


EXPOSE 2222

