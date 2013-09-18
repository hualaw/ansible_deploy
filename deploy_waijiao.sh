#!/bin/sh

################# checkout projects

PACKAGE=waijiao
GIT_REPO=git@192.168.11.11:liuhua/php_91waijiao.git
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
