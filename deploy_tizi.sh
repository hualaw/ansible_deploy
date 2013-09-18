#!/bin/sh

################# checkout projects

PACKAGE=tizi
GIT_REPO=git@192.168.11.11:liuhua/zujuan_teacher.git
INVENTORY=ansible_inventory
SSHKEY=~/.vagrant.d/insecure_private_key
LOCAL_PATH=./local/$PACKAGE
TAG=master

DIR=`dirname $0`
PROG=`basename $0`

. $DIR/functions

checkout $GIT_REPO $LOCAL_PATH $TAG
build_package $PACKAGE $LOCAL_PATH
install_package $PACKAGE $SSHKEY $INVENTORY

