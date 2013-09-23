depends
--------------

pip install ansible

# for flatform indepent password generator
pip install passlib
pip install python-gflags

########################
new server
1. set root password
   ip --> root
2. setup deploy user
    sh ./ssh/init_ssh.sh
3. deploy init server
    ansible-playbook -vvv --private-key=./ssh/ansible_id_rsa -i production tizi_init.yml
    ansible-playbook -vvv --private-key=./ssh/ansible_id_rsa -i production --tags redis --limit intra tizi_init.yml


###################
monit --> nginx php5-fpm mysql redis

原来的做法  /etc/init.d/nginx stop
现在的做法  monit stop nginx

