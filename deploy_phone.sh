#!/bin/bash

################# checkout projects

set -e

DIR=`dirname $0`
PROG=`basename $0`

usage() {
  cat <<EOF
usage:
  $PROG -p package -b branch -g git_repo -k sshkey -i inventory_file -t ansible_tag -u deploy_user

OPTIONS:
  -p   package name
  -g   git repotory
  -b   checkout specific branch
  -i   ansible inventory file 
  -k   use ssh private key
  -t   ansible tags
  -h   help

EOF
}

PACKAGE=phone
GIT_REPO=git@192.168.11.11:chris/phone_server.git
SSHKEY=./ssh/ansible_id_rsa
INVENTORY=production
BRANCH=master
TAG=phone
LIMIT=phone

#SERVERS=(112.124.41.101)
DEPLOY_USER=deploy

while getopts "hp:g:i:k:t:b:" OPTION
do
  case $OPTION in
    p)
      PACKAGE=$OPTARG
      ;;
    g)
      GIT_REPO=$OPTARG
      ;;
    i)
      INVENTORY=$OPTARG
      ;;
    k)
      SSHKEY=$OPTARG
      ;;
    b)
      BRANCH=$OPTARG
      ;;
    t)
      TAG=$OPTARG
      ;;
    u)
      DEPLOY_USER=$OPTARG
      ;;
    h)
      usage
      exit 1
      ;;
  esac
done

LOCAL_PATH=./local/$PACKAGE

. $DIR/functions

checkout $GIT_REPO $LOCAL_PATH $BRANCH
build_package $PACKAGE $LOCAL_PATH
install_package $PACKAGE $SSHKEY $INVENTORY $TAG $LIMIT

