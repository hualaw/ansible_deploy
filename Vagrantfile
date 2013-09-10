# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "precise32"
  config.vm.box_url = "http://192.168.11.11/precise32.box"
  #config.vm.box_url = "http://files.vagrantup.com/precise32.box"

  #config.vm.network :forwarded_port, guest: 80, host: 8012
  #config.vm.network :public_network
  config.vm.network :private_network, ip: "192.168.91.2"

  config.ssh.forward_agent = true

  #config.vm.provision :shell, :path => "bootstrap.sh"
  config.vm.provision "ansible" do |ansible|
    ansible.inventory_file = "./ansible_inventory"
    ansible.playbook = "site.yml"
    ansible.verbose = true
  end

  #config.vm.synced_folder "../data", "/vagrant_data"

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "1024"]
  end
end
