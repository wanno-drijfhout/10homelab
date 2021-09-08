# Becoming an administrator

## Create SSH keys

[Full instructions](https://www.digitalocean.com/community/tutorials/how-to-set-up-ssh-keys-2).

To create a root-key on the hypervisor, run:

```bash
ssh-keygen -t ed25519
cat ~/.ssh/id_ed25519.pub >> ~/.ssh/authorized_keys
```

Copy the private key (`~/.ssh/id_ed25519`) to your local machine and register with an SSH agent (e.g., KeepassXC). Test that you can log in without password.

Once you have copied your SSH keys onto your server, log in to ensure that you can log in with the SSH keys alone (i.e., without password). If that is the case, you can go ahead and restrict the root login to only be permitted via SSH keys. Edit `/etc/ssh/sshd_config`:

```
PermitRootLogin without-password
```

Then, run:

```bash
systemctl reload sshd.service
```

## Prepare Ansible on hypervisor

You will need to use Ansible to deploy 10homelab. Install Ansible on a Linux machine (e.g., your PC or the Proxmox hypervisor).

Add to `/etc/apt/sources.list`:

```list
deb http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main
```

and then:

```bash
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367
apt update
apt install ansible
```

Copy this directory to the hypervisor (or use `deploy.ps1`):

```bash
scp -r . root@10.69.1.10:
scp -r ./hosts root@10.69.1.10:/etc/ansible/hosts
```

Test Ansible:

```bash
ansible all -m ping
```

If you have checked out 10homelab on a different computer than where you installed Ansible, copy your 10homelab folder to that computer. Check out `deploy.ps1` for inspiration.

On the computer with Ansible, working in the directory of 10homelab, run the playbook:

```bash
ansible-playbook
```
