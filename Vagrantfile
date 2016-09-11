# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
    vb.customize ["modifyvm", :id, "--memory", 2048]
    vb.customize ["modifyvm", :id, "--cpus", 2]
  end

  config.vm.box = "ubuntu/trusty64"

  config.vm.provision :shell, inline: <<-SHELL
    if [ ! -f ~/.runonce ]
    then
      sudo apt-get install --reinstall -y language-pack-en
      sudo locale-gen "en_US.UTF-8"
      sudo dpkg-reconfigure locales

      echo 'LC_ALL="en_US.UTF-8"' | sudo tee -a /etc/default/locale
      echo 'LANG="en_US.UTF-8"' | sudo tee -a /etc/default/locale

      # Link the repo
      cd /home/vagrant/
      ln -s /vagrant /home/vagrant/meppit
      touch ~/.runonce
    fi
  SHELL

  # config.vm.provision :shell, :path => "bootstrap.sh"


  #-----------------Network
  # config.vm.network :private_network, ip: "192.168.56.101"

  # App server
  config.vm.network :forwarded_port, guest: 3000, host: 3000, auto_correct: true
  config.vm.network :forwarded_port, guest: 3500, host: 3500, auto_correct: true
end
