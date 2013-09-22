#!/bin/sh

################# checkout projects

DIR=`dirname $0`
PROG=`basename $0`

usage() {
  cat <<EOF
usage:
  $PROG -p package -t gittag -g git_repo -k sshkey -i inventory_file -l ansible-limit -a ansible-tag

OPTIONS:
  -p   package name
  -g   git repotory
  -i   ansible inventory file 
  -k   use ssh private key
  -t   checkout specific tags
  -a   ansible tag
  -l   ansible hosts limit
  -v   verbose
  -h   help

EOF
}

PACKAGE=waijiao
GIT_REPO=git@192.168.11.11:liuhua/php_91waijiao.git
INVENTORY=production
SSHKEY=./ssh/ansible_id_rsa
TAG=master
VERBOSE=
ANSIBLE_LIMIT=
ANSIBLE_TAG=

while getopts "hvp:g:i:k:t:l:a:" OPTION
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
    t)
      TAG=$OPTARG
      ;;
    l)
      ANSIBLE_LIMIT=$OPTARG
      ;;
    a)
      ANSIBLE_TAG=$OPTARG
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

LOCAL_PATH=./local/$PACKAGE

. $DIR/functions

checkout $GIT_REPO $LOCAL_PATH $TAG
build_package $PACKAGE $LOCAL_PATH 
install_package $PACKAGE $SSHKEY $INVENTORY 
