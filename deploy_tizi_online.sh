#!/bin/sh

################# checkout projects

PACKAGE=tizi
GIT_REPO=git@192.168.11.11:liuhua/zujuan_teacher.git
INVENTORY=production
SSHKEY=./ssh/ansible_id_rsa
LOCAL_PATH=./local/$PACKAGE
TAG=0.1

DIR=`dirname $0`
PROG=`basename $0`

. $DIR/functions

checkout $GIT_REPO $LOCAL_PATH $TAG
build_package $PACKAGE $LOCAL_PATH
install_package $PACKAGE $SSHKEY $INVENTORY

