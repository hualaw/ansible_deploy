#!/bin/sh

################# checkout projects


GIT_REPO=git@192.168.11.11:liuhua/zujuan_teacher.git
PACKAGE=tizi
LOCAL_PATH=./local/$PACKAGE

if [ ! -d $LOCAL_PATH ]; then
  git clone $GIT_REPO $LOCAL_PATH
else
  pushd .
  cd $LOCAL_PATH
  # remove any local unstaged changes
  git clean -f
  git reset --hard
  # checkout master
  git checkout master
  # pull lastest change
  git pull origin master
  popd
fi

################# make packages

#cp ./bin/deploy_bootstrap.sh $LOCAL_PATH/.
#./bin/makeself.sh $LOCAL_PATH deploy-`date "+%Y%m%d%H%M%S"`.run "deploy installer" ./deploy_bootstrap.sh

pushd .
cd $LOCAL_PATH/..
tar --exclude=.git* --exclude=*.tar.gz -czf $PACKAGE.tar.gz .
popd
/bin/cp -f $LOCAL_PATH/../$PACKAGE.tar.gz roles/$PACKAGE/files

################# deploy to remote system

ansible-playbook -v --private-key=~/.vagrant.d/insecure_private_key  -i ansible_inventory $PACKAGE.yml

