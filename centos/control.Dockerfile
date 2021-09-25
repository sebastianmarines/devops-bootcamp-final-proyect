FROM robertdebock/docker-centos-openssh:latest

COPY ./keys/id_rsa /root/.ssh/id_rsa

RUN chmod 400 /root/.ssh/id_rsa