#!/bin/sh

ansible-playbook -vvv --private-key=./ssh/ansible_id_rsa.pub -i production tizi_init.yml

