# Ansible and my projects
Ansible is an open-source IT automation tool that simplifies tasks like configuration management, application deployment, and orchestration. It is agentless, meaning it does not require software to be installed on the managed nodes, and it uses a simple, human-readable language for its configurations [(YAML)](https://yaml.org).
## Historical Stuff
Ansible was ivented in 2012 by Michael DeHaan, then it was acquired by [Red Hat](https://www.redhat.com/) in 2015. [Ansible](https://docs.ansible.com) is a toolset with several tools, modules and it is also an extensible framework. Them main components of Ansible are modules, executables, playbooks and inventories. Ansible can target many sistems like hosts, network devices, containers and storage arrays. When is used SSH to secure the channel configuration Ansible use [Diffie–Hellman](https://en.wikipedia.org/wiki/Diffie%E2%80%93Hellman_key_exchange) algoritm to create a simetric key.

## Where I use it
I use Rocky Linux for the enterprise stuff (The comunity "Red Hat") then the examples and installation are made using this Linux distro.
- [Rocky Linux](https://rockylinux.org)
## Ansible Instalation
As I use Rocky Linux it is very simple to install. After you install your Rocky Linux just do this:
~~~bash
#!/etc/bash
# Update Rocky Linux distro
sudo yum update -y
# Install the EPEL(Extra Packages Repository for Linux)
sudo yum install epel-release -y
# Finaly install the Ansible pakage
sudo yum install ansible -y
~~~
### 
### Configuring SSH for Passwordless Access
Ansible communicates with managed nodes over SSH. We can config inventory(the list of target nodes) with username and password or we can use SSH key-based authentication. To enable password less access to these nodes, you need to set up SSH key-based authentication. To permit that Ansible automatically accept Host Keys Fingerprints you have to set the SSH option StrictHostKeyChecking=no.
#### On the control node
- If you don't have a SSH key pair you have to generate one with [ssh-keygen](https://www.man7.org/linux/man-pages/man1/ssh-keygen.1.html):
~~~bash
ssh-keygen -t rsa
~~~ 
Note: Press Enter to accept the default location and leave the passphrase empty for password less access
#### On the managed node
- You can, manualy, copy the public key (.ssh/id_rsa.pub) to the file authorized_keys inside the .ssh folder in the remote user (.ssh/authorized_keys) on each managed node, or use the comand [ssh-copy-id](https://www.man7.org/linux/man-pages//man1/ssh-copy-id.1.html):
~~~bash
ssh-copy-id username@managed_node_ip
~~~
Note: After configuring you can use the comand ansible -i -m ping, to get the response from the hosts,  [-i is for inventory and -m for using modules](https://linux.die.net/man/1/ansible).
## Ansible arquitecture
First of all you can see the version of Ansible and the location of config file, with:
~~~bash
ansilble --version
~~~
- The Ansible config files in Rocky Linux are in '/etc/ansible'
- Inside this directory you have tree files:
  - ansible.cfg -> Where we have the ansible configurations, then is the configuration file;
  - hosts -> Contains the devices that we are going to control, refered as the inventory file (Linux, Windows, Routers, Switches,etc);
  - roles (a folder) ->
### CONFIGURATION FILE
- The configuration file with for example the option to use, or not(not recomended) the validation of ssh keys
  - You can generate a config file
~~~bash
ansible-config init --disabled > ansible.cfg
~~~
  - You can also have a more complete file that includes existing plugins
~~~bash
ansible-config init --disabled -t all > ansible.cfg
~~~
- You can see what config file Ansible is using, knowing that it can use:
  - ANSIBLE_CONFIG, this envoriment varible cn be set to any name that you put the Ansible config;
  - ansible.cfg inside the directory that you are using, you can have several config's by directory;
  - .ansible.cfg, an iden file inside the user home directory;
  - /etc/ansible/ansible.cfg, file inside /etc/ansible that is typically provided by packaged instalation.  
### hosts
- You can edit this file and at the end create groups bethen brackets and put a name on it like [servers], [routers], [switches], etc;
- After each group you can put the IP adress of each device tha you  waht to control;
- For each group you should create a group of variables that are use for the group with [servers:vars];
### roles
-
### Playbooks
An Ansible Playbook is the core componente of Ansible used for configuration management, aplication depoyment, and task automation.
It is a set of instructions  written in [YAML](https://yaml.org) that describes the designed state of your systems.
Ansible read this playbook and executes the necessary tasks on your hosts (servers,network devices, etc.) to achive that state.
It is like a script , but it is specifically design for automation.

They key concepts  and componentes within a playbook are:
- YAML Format: Playbooks are witten in [YAML](https://yaml.org) because YAML  is a human-friendly data serialization language for all programming languages;
- Plays : A playbook contains one or more plays. Each play define a set of tasks to be executed on a specific group of hosts:
  - A play typically start with '---' (optional, but good practice) at the top level;
  - It defines the target in 'hosts';
  - It can define vars (variables) specific to that play;
  - It contain a list of tasks.
- Hosts: This keyword specifies which managed nodes (servers or devices) the play should target.This references hosts or groups defined in your Ansible Inventory file (a separate file listing your managed machines).
  - examples:  hosts: webservers, hosts: all, hosts: database_servers:!secondary
- Tasks: Tasks are the individual actions Ansible performs. Each task calls an Ansible module.
  - Tasks are executed sequentially within a play.
  - Each task typically has a name for descriptive output.
  - It calls a specific module (e.g., apt, yum, copy, service, template, command).
  - It provides arguments required by that module.
- Modules: These are the actual units of code that Ansible executes. Ansible comes with hundreds of built-in modules for managing packages, services, files, users, networking, cloud resources, and much more. Tasks simply call these modules with the correct parameters.
- Variables (vars): Variables allow you to make playbooks dynamic and reusable. You can define variables at different levels (in the play, in included files, in the inventory, passed via command line).
  - Example: vars: http_port: 80
- Handlers: Handlers are special tasks triggered by a notify directive in another task. They typically run only if a task makes a change and usually involve actions like restarting services. Handlers are executed only once at the end of the play, even if notified multiple times.
  - Example: A task that copies a configuration file might notify: Restart Nginx. The handler named Restart Nginx would then use the service module to restart the Nginx service.
- Roles: For complex scenarios, playbooks can become long. Roles provide a way to structure and organize your automation content by grouping related tasks, variables, files, templates, and handlers into reusable units.
- Idempotency: A key principle in Ansible. Playbooks are generally designed to be idempotent. This means running the playbook multiple times will result in the same system state. If a system is already in the desired state described by a task, Ansible won't make any changes for that task.

- Example of a playbook:

~~~yaml
- name: Configure web server
  hosts: webservers # Target hosts defined in your inventory
  become: yes      # Execute tasks with administrative privileges (e.g., sudo)

  vars:
    nginx_package_name: nginx # Define a variable

  tasks:
    - name: Ensure Nginx is installed
      ansible.builtin.apt: # Using the apt module (for Debian/Ubuntu)
        name: "{{ nginx_package_name }}" # Use the variable here
        state: present       # Ensure the package exists
        update_cache: yes    # Update apt cache first

    - name: Ensure Nginx configuration file is copied
      ansible.builtin.copy:
        src: files/nginx.conf # Local file on the Ansible control node
        dest: /etc/nginx/nginx.conf # Destination on the target node
        owner: root
        group: root
        mode: '0644'
      notify: Restart Nginx # Trigger the handler if this task makes a change

    - name: Ensure Nginx service is started and enabled
      ansible.builtin.service:
        name: "{{ nginx_package_name }}"
        state: started       # Ensure the service is running
        enabled: yes         # Ensure the service starts on boot
  handlers:
    - name: Restart Nginx
      ansible.builtin.service:
        name: "{{ nginx_package_name }}"
        state: restarted
~~~
- How to Run
  - You execute a playbook from your Ansible control node using the ansible-playbook command:
    - ansible-playbook webserver.yml
  - Or if your inventory isn't in the default location:
  - ansible-playbook -i /path/to/your/inventory webserver.yml

### Testing and executing ansible comands
- For testing your configuration file you can use 'ansible servers -m ping' (it uses module ping to ping the devices in [servers] group);
- For executing comands in all machines from a group you can, for example, use 'ansible servers -a "cat /etc/os-release" or to reboot all machines 'ansible servers -a "reboot";


### Comunity documentation

- [Ansible Documentation](https://docs.ansible.com)
- [YAML Documentation](https://yaml.org)
- [SSH key gen](https://www.ssh.com/academy/ssh/keygen)
