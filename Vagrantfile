# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.box = "pgraffigna/windows10-64"
  config.vm.guest = :windows
  config.vm.communicator = "winrm"
  config.winrm.username = "vagrant"
  config.winrm.password = "vagrant"
  config.vm.boot_timeout = 600
  config.vm.network :forwarded_port, guest: 3389, host: 3389
  config.vm.network :forwarded_port, guest: 5985, host: 5985, id: "winrm", auto_correct: true

  
  config.vm.define "virtual" do |v|
    v.vm.network "private_network", ip: "192.168.60.10"
    v.vm.hostname = "windows10"
  
    config.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
      vb.cpus = 2
      vb.name = "Windows10-BOX"
      vb.check_guest_additions = false
      vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"] 
      vb.customize ["modifyvm", :id, "--ioapic", "on"] 
    end  
  end
end