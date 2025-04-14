# This is my simple utilization of Ansible
I use Rocky Linux then the examples and instalation are made in this Linux distro.
## Ansible Instalation
As I use Rocky Linux it is very simple to install. After you install your Rocky Linux just:
- Update Rocky Linux distro 'yum update -y'
- Install the EPEL(Extra Packages Repository for Linux) 'yum install epel-release -y'
- Finaly install Ansible 'yum install ansiible -y'
## Ansible details
- The Ansible is instaled in '/etc/ansible'
- Inside this directory you have tree files:
  - ansible.cfg -> Where we have the ansible configurations, then is the configuration file;
  - hosts -> Contains the devices that we are going to control, refered as the inventory file (Linux, Windows, Routers, Switches,etc);
  - roles (a folder) ->
### ansible.cfg
- The configuration file with for example the option to use, or not(nto recomended) the validation of ssh keys
### hosts
- You can edit this file and at the end create groups bethen brackets and put a name on it like [servers], [routers], [switches], etc;
- After each group you can put the IP adress of each device tha you  waht to control;
- For each group you should create a group of variables that are use for the group with [servers:vars];

### Testing and executing ansible comands
- For testing your configuration file you can use 'ansible servers -m ping' (it uses module ping to ping the devices in [servers] group);
- For executing comands in all machines from a group you can, for example, use 'ansible servers -a "cat /etc/os-release" or to reboot all machines 'ansible servers -a "reboot";


