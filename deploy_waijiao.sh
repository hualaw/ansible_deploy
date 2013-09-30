#!/bin/sh

################# checkout projects

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

PACKAGE=waijiao
GIT_REPO=git@192.168.11.11:liuhua/php_91waijiao.git
SSHKEY=./ssh/ansible_id_rsa
INVENTORY=production
BRANCH=master
TAG=waijiao
LIMIT=waijiao-webserver

SERVERS=(112.124.41.101)
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
for server in ${SERVERS[@]}; do
  rsync_package $DEPLOY_USER $server /home/$DEPLOY_USER $LOCAL_PATH
done
install_package $PACKAGE $SSHKEY $INVENTORY $TAG $LIMIT

