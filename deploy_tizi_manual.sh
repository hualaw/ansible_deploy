#!/bin/bash

################# checkout projects

DIR=`dirname $0`
PROG=`basename $0`

usage() {
  cat <<EOF
usage:
  $PROG -p package -b branch -g git_repo -k sshkey -i inventory_file -l limit_hosts -t ansible_tag -u deploy_user

OPTIONS:
  -p   package name
  -g   git repotory
  -b   checkout specific branch
  -i   ansible inventory file 
  -k   use ssh private key
  -l   limit hosts
  -t   ansible tags
  -h   help

EOF
}

PACKAGE=tizi
GIT_REPO=git@192.168.11.11:liuhua/zujuan_teacher.git
SSHKEY=./ssh/ansible_id_rsa
INVENTORY=production
BRANCH=master
TAG=tizi
LIMIT=tizi-webserver

DEPLOY_USER=waijiao
SERVERS=(121.199.20.59)

while getopts "hp:g:i:k:t:l:b:u:" OPTION
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
    l)
      LIMIT=$OPTARG
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
for server in ${SERVERS[@]}; do
  rsync_package $DEPLOY_USER $server /home/$DEPLOY_USER $LOCAL_PATH 9191
  install_tizi_manual 9191 $DEPLOY_USER $server $LOCAL_PATH $PACKAGE
done
