# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.require_version ">= 1.7.2"

Vagrant.configure(2) do |config|
  config.vm.box = "debian/jessie64"
  config.vm.box_check_update = false
  config.ssh.insert_key = false

  config.vm.define "master" do |master|
    master.vm.network "private_network", ip: "192.168.56.33"
    config.vm.hostname = "satan"

    master.vm.provider "virtualbox" do |vbmaster|
      vbmaster.check_guest_additions = false
      vbmaster.functional_vboxsf = false
      vbmaster.memory = "256"
      vbmaster.cpus = "1"
    end
  end
end
