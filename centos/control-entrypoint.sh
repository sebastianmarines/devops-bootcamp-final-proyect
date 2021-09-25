#!/bin/bash
ssh-keyscan -H host >> /root/.ssh/known_hosts
ansible-playbook /root/scripts/main.yml