# -*- mode: ruby -*-
# vi: set ft=ruby :

NUM_WORKERS = 2

Vagrant.configure("2") do |config|

  config.vm.provider "virtualbox" do |vb|
     vb.gui = false
     vb.memory = "4192"
     vb.cpus = 2
  end

  # K8s Master
  config.vm.define "k8s-master" do |conf|
    conf.vm.box = "peru/ubuntu-20.04-server-amd64"
    conf.vm.hostname = 'k8s-master1.local'
    conf.vm.network "private_network", ip: "192.168.20.10"
    conf.vm.provision "shell", path: "bootstrap.sh"
  end

  # K8s Workers
  (1..NUM_WORKERS).each do |n|
    config.vm.define "k8s-worker#{n}" do |worker|
      worker.vm.box = 'peru/ubuntu-20.04-server-amd64'
      worker.vm.hostname = "k8s-worker#{n}.local"

      worker.vm.network 'private_network', ip: "192.168.20.2#{n}"
      worker.vm.provision "shell", path: "bootstrap.sh"

      worker.vm.provider 'virtualbox' do |vb|
        vb.memory = '4192'
        vb.cpus = 1
      end

    end
  end

end