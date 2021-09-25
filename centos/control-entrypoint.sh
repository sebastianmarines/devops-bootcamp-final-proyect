#!/bin/bash
ssh-keyscan -H host >> /root/.ssh/known_hosts
ansible all -m ping