#!/bin/sh

DIR=`dirname $0`
PROG=`basename $0`

usage() {
  cat <<EOF
usage:
  $PROG -p package -k sshkey -i inventory_file 

OPTIONS:
  -p   package name
  -i   ansible inventory file 
  -k   use ssh private key
  -v   verbose output
  -h   help

EOF
}

PACKAGE=tizi_init
INVENTORY=production
SSHKEY=./ssh/ansible_id_rsa
VERBOSE=

while getopts "hvp:i:k:" OPTION
do
  case $OPTION in
    p)
      PACKAGE=$OPTARG
      ;;
    i)
      INVENTORY=$OPTARG
      ;;
    k)
      SSHKEY=$OPTARG
      ;;
    v)
     VERBOSE=vv
     ;;
    h)
      usage
      exit 1
      ;;
  esac
done

ANSIBLE_MODULE_LANG=en_US.UTF-8 ansible-playbook -${VERBOSE}v --private-key=$SSHKEY -i $INVENTORY $PACKAGE.yml

