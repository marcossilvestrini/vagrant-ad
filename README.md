# Provision Stack Windows Server: AD and DNS Server
![vagrant-heart-windows](https://user-images.githubusercontent.com/62715900/95867284-5d0a7800-0d3f-11eb-8bf3-0e48db6efd19.jpg)


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

- [Git](https://git-scm.com/doc)
- [VirtualBox](https://www.virtualbox.org/wiki/Documentation)
- [Vagrant](https://www.vagrantup.com/docs/index.html)
- [Ansible](https://docs.ansible.com/ansible/latest/index.html)
- [Powershell modules used in this project](https://docs.microsoft.com/en-us/powershell/module/)
- [Active Directory with DSC](http://www.ntweekly.com/2020/08/28/create-organizational-units-with-ansible-on-active-directory/)

## Install Vagrant in Rhel Centos 7\8

### Download

- Version 2.2.10
- https://releases.hashicorp.com/vagrant/2.2.10/vagrant_2.2.10_x86_64.rpm
- `sudo wget https://releases.hashicorp.com/vagrant/2.2.10/vagrant_2.2.10_x86_64.rpm`

### Install

- `sudo yum localinstall vagrant_2.2.10_x86_64.rpm -y`
- `vagrant ––version`

### Install Vagrant Plugins

- `vagrant plugin install vagrant-hostmanager`
- `vagrant plugin install vagrant-reload`
- `vagrant plugin install vagrant-scp`
- `vagrant plugin install vagrant-vbguest`

## Create Box

- clone this reposotory
- `cd vagrant-ad`
- `vagrant up`
- `vagrant status`
- `vagrant ssh`

## Base Vagrantfile

- Set Hostname
- Set ressources memory and cpu
- Configure Network and forwarded port
- Configure Mounts
- Setup Ansible
- Provisioning

## Fix Error SSH in Vagrant Windows

- Run this command in powershell:
- $Env:VAGRANT_PREFER_SYSTEM_BIN += 0

## Tasks Active Directory and DNS

- Install Features AD and DNS
- Install-ADDSForest
- Create OU's (production,ha,dev)
- Create DNS Primary Zone
- Create Reverse Lookup Zone.
- Add A Host Records
- Add PTR Reverse Zone
- Set Default DNS server
- Create Domain Groups
- Add Users in Domain Groups
- Join Server Client in Active Directory

## Playbooks

- domain_controler: Install and Configure Domain Controler
- dns: Configure DNS Server
- groups_users: Configure Groups and Users in Domain
- client_server: Join cliente servers in Forest\Domain\OU's

## Roles

### commons

- Disable IPV6
- Disable Firewall
- Enable Remote Access
- Setup Powershell
- Create local users
- Install Packages

### domain_controler

- Install Windows Server Features
- Create new Windows Domain in a New Forest

### dns

- Create Primary Zone
- Create Reverse Lookup Zone
- Add A Host Records
- Create PTR Reverse Zone
- Set Default DNS for public interface

### groups_users

- Install Nuget
- Install XactiveDirectory
- Create OU's
- Create Groups
- Add User in Group Development
- Add User in Others Groups

### join_servers

- Set Default DNS
- Join to the domain
