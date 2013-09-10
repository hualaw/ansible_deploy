#!/bin/sh

ansible-playbook -v --private-key=~/.vagrant.d/insecure_private_key  -i ansible_inventory site.yml
