# CapRover Server Deployment via Ansible

This repository contains a complete Ansible playbook to automatically provision and configure a server for [CapRover](https://caprover.com) deployment. It includes:

- UFW firewall setup with safe defaults
- SSH access configuration
- Docker & CapRover installation
- Optional SSH tunneling setup for secure PostgreSQL access

## Prerequisites

- Ansible installed on your local machine
- SSH access to the target server
- A valid SSH private key (`~/.ssh/id_rsa` by default)
- A properly configured `inventory/hosts.yml` file with your server details
- sudo apt install python3-requests might need in some server in root.

## Inventory Example

hosts.yml

```yaml
all:
  vars:
    ansible_ssh_private_key_file: ~/.ssh/id_rsa
    ansible_python_interpreter: /usr/bin/python3

  children:
    caprover_servers:
      hosts:
        caprover_server_1:
          ansible_host: 159.65.x.x
          ansible_user: caprover_lara
```

### Usage

To run the full deployment:

```bash
ansible-playbook -i inventory/hosts.yml site.yml
```

`ansible-playbook site.yml` will do as inventory is set in ansible.cfg.

This will:

Install UFW and configure safe firewall rules

Allow necessary CapRover ports: 80, 443, 3000

Allow SSH (22)

Install Docker

Install and configure CapRover

### PostgreSQL Access via SSH Tunnel (Optional)

If using CapRover’s PostgreSQL service and want to connect from DBeaver or a local client:

```sh
ssh -L 5432:localhost:5432 caprover_lara@<server-ip>
```

Then connect to localhost:5432 in your DB client.
You do NOT need to open port 5432 in the firewall when using an SSH tunnel.
