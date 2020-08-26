# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

# INSTALL PLUGIN RELOAD
unless Vagrant.has_plugin?("vagrant-reload")
  puts 'Installing vagrant-reload Plugin...'
  system('vagrant plugin install vagrant-reload')
end

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # Box Windows Server 2019 Standart
  config.vm.box = "gusztavvargadr/windows-server-standard-core"

  # VM AD
  config.vm.define "srvdc01" do |srvdc01|

    # VARIABLE HOSTNAME
    VM_DC_NAME= "win2019-srvdc01"

    # Set Others parameters for windows vm
    srvdc01.vm.guest = :windows
    srvdc01.vm.communicator = "winrm"
    srvdc01.vm.boot_timeout = 1200
    srvdc01.vm.graceful_halt_timeout = 600
    srvdc01.winrm.retry_limit = 200
    srvdc01.winrm.retry_delay = 10
    srvdc01.winrm.timeout = 1800
    srvdc01.winrm.max_tries = 20
    srvdc01.winrm.transport = :plaintext
    srvdc01.winrm.basic_auth_only = true

    # HOSTNAME
    srvdc01.vm.hostname = VM_DC_NAME

    # NETWORK
    srvdc01.vm.network "public_network" ,ip: "192.168.0.132"
    #srvdc01.vm.network "forwarded_port", guest: 5432, host: 5432, adapter: 1 , guest_ip: "192.168.0.132" ,host_ip: "192.168.0.33"

    # MOUNTS
    srvdc01.vm.synced_folder ".", "/vagrant", disabled: true
    srvdc01.vm.synced_folder "./scripts", "/scripts"

    # PROVIDER
    srvdc01.vm.provider "virtualbox" do |vb|
      vb.name = VM_DC_NAME
      vb.memory = 2048
      vb.cpus = 3
    end

    # PROVISION

    # FIX  WinRM::WinRMAuthorizationError
     #srvdc01.vm.provision "shell", inline: "& C:\scripts\fix_winrm.bat"

    # DEFAULT ROUTER
    srvdc01.vm.provision "shell", inline: <<-SHELL
      $wmi= Get-WmiObject win32_networkadapterconfiguration |
        Where-Object{$_.IPAddress -like "*192.168.0*"}
      $wmi.SetGateways("192.168.0.1", 1)
    SHELL

    # INITIAL SETUP
    srvdc01.vm.provision "shell", path: "scripts/setup.ps1"

    # INSTALL AD
    srvdc01.vm.provision "shell", path: "scripts/setup_ad.ps1"
    srvdc01.vm.provision :reload
    srvdc01.vm.provision "shell", inline: "echo 'INSTALLER: Setup complete, Active Directory Configured with success!'"

    # CREATE FOREST
    srvdc01.vm.provision "shell", path: "scripts/setup_ad_groups.ps1"
    srvdc01.vm.provision "shell", inline: "echo 'INSTALLER: Create AD Groups with success!'"

    # SETUP AD
    srvdc01.vm.provision "shell", path: "scripts/setup_dns.ps1"
    srvdc01.vm.provision :reload
    srvdc01.vm.provision "shell", inline: "echo 'INSTALLER: Setup complete, DNS Configured with success!'"

  end

  # # VM CLIENT
  # config.vm.define "srv01" do |srv01|

  #   # VARIABLE HOSTNAME
  #   VM_CLIENT_NAME= "win2019-srv01"

  #   # HOSTNAME
  #   srv01.vm.hostname = VM_CLIENT_NAME

  #   # NETWORK
  #   srv01.vm.network "public_network" ,ip: "192.168.0.133"
  #   #srv01.vm.network "forwarded_port", guest: 5432, host: 5432, adapter: 1 , guest_ip: "192.168.0.132" ,host_ip: "192.168.0.33"

  #   # MOUNTS
  #   srv01.vm.synced_folder ".", "/vagrant", disabled: true
  #   srv01.vm.synced_folder "./scripts", "/scripts"

  #   # PROVIDER
  #   srv01.vm.provider "virtualbox" do |vb|
  #     vb.name = VM_CLIENT_NAME
  #     vb.memory = 2048
  #     vb.cpus = 3
  #   end

  #   # PROVISION
  #    # SSH,FIREWALLD AND SELINUX
  #   srv01.vm.provision "shell", inline: <<-SHELL
  #     Get-ExecutionPolicy
  #   SHELL

  # end

end