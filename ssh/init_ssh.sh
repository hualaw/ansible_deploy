#!/bin/sh

init_ssh() {
  mkdir -p $1/.ssh
  echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD2wEZcV5atbI2q8IaYLa2iR7kY64vsP3MHlbkCiLBkLIKDvT0W+/xSJwZyH5UJUVRDU+QRnTTCjjL0Gj5RBU2GbwPUzA+TkGkyOMDTzhFQTTfuZI/oYx8qFzZEmchdnqK8/3FqyhUe7amNQVObFbV0jrZPk+Mx/ia249DNyeGfAW9uY1mDeIqvi07EjoPsHyyJPa50z2X3NjMoUsiFLEy+6DPjlrY44KJkFQA2Bvkja8SMiq6OjhZpsmr/EZbly8dAVHRT1RgbKrfvz1D0NYITLKmgGBqGFhkeuI2RZ/iwYxrSdaErX3OEYIEhThmFTPy7V0+Iyr6fed6Pf6S0jnRB deploy" > $1/.ssh/authorized_keys
  if [ ! -L $1/.ssh/authorized_keys2 ]; then
    ln -s $1/.ssh/authorized_keys $1/.ssh/authorized_keys2
  fi
  chmod -R og-rwx $1/.ssh
}

# should run as root
init_ssh ~

# create deploy user
if id -u deploy >/dev/null 2>&1; then
  echo "deploy user already exits, skipping create, initialize ssh keys.."
else
  useradd --create-home deploy
fi

init_ssh /home/deploy
chown -R deploy:deploy /home/deploy

# add deploy user into sudo group
sed -i -e '$ a\deploy ALL=(ALL:ALL) NOPASSWD:ALL' /etc/sudoers

