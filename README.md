# Provision Stack Windows Server: AD and DNS Server

## Getting Started

- Fork the project and enjoy.
- Atention for pre requisites and License!!!

## Prerequisites

- Git
- Virtual Box
- Vagrant
- Ansible
- Python

## Authors

- Marcos Silvestrini

## License

- This project is licensed under the MIT License - see the LICENSE.md file for details

## References

- Git: <https://git-scm.com/doc>
- VirtualBox: <https://www.virtualbox.org/wiki/Documentation>
- Vagrant: <https://www.vagrantup.com/docs/index.html>
- Ansible: <https://docs.ansible.com/ansible/latest/index.html>
- Powershell modules used in this project:<https://docs.microsoft.com/en-us/powershell/module/>

## Install Vagrant in Rhel Centos 7\8

### Download

- Version 2.2.9
- <https://releases.hashicorp.com/vagrant/2.2.9/vagrant_2.2.9_x86_64.rpm>
- sudo wget <https://releases.hashicorp.com/vagrant/2.2.9/vagrant_2.2.9_x86_64.rpm>

### Install

- sudo yum localinstall vagrant_2.2.9_x86_64.rpm -y
- vagrant ––version

### Install Vagrant Plugins

vagrant plugin install vagrant-hostmanager
vagrant plugin install vagrant-reload
vagrant plugin install vagrant-scp
vagrant plugin install vagrant-share
vagrant plugin install vagrant-vbguest

## Create Box

- clone this reposotory
- cd vagrant-ad
- vagrant up
- vagrant status
- vagrant ssh

## Base Vagrantfile

- Set Hostname
- Set ressources memory and cpu
- Configure Network and forwarded port
- Configure Mounts

## Fix Error SSH in Vagrant Windows

- Run this command in powershell:
- $Env:VAGRANT_PREFER_SYSTEM_BIN += 0

## Setup VM

- Disable IPV6
- Disable Firewall
- Enable Remote Access
- Setup Powershell
- Create local users
- Install Packages

## Setup Active Directory and DNS

- Install Features AD and DNS
- Install-ADDSForest
- Create AD Groups (production,ha,dev)
- Create DNS Primary Zone
- Create Reverse Lookup Zone.
- Set Default DNS server
