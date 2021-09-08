# Docker Swarm

Setting up a Docker (Linux) Swarm node cluster requires a number of steps.

## Create Virtual Machine

Ensure the values correspond to the inventory file!

- General:
  - VM ID: `69010123` (10.**69.010.123**; substitute as relevant)
  - Name: e.g., `app-node-0`
  - Start at boot: *checked*
- OS:
  - Use [Ubuntu Server 20.04](https://ubuntu.com/download/server)
- System:
  - Qemu Agent: *unchecked* (for now) (NOTE! Qemu guest agent must be installed and started before stopping the machine; otherwise Proxmox will hang)
- Hard Disk:
  - Storage: `local-lvm`
  - Disk size (GiB): `32`
  - SSD emulation: *checked*
  - Backup: *checked*
  - Skip replication: *enabled*
- CPU:
  - Type: `host`
  - Cores: `4`
  - Enable NUMA: *checked*
- Memory:
  - Memory (MiB): `16384` (= 16 GiB)
  - Minimum memory (MiB): `1024`

Afterwards:

- Add a USB device (host=1-3,usb3=1) so that `/dev/ttyUSB0` is accessible to the VM (useful for ESPHome)

## Configure Ubuntu

Open the noVNC terminal and install Ubuntu server.

- Configure IPv4:
  - Subnet: `10.<<XX>>.0.0/16`
  - Address: `10.<<XX>>.10.0`
  - Gateway: `10.<<XX>>.1.1`
  - Name servers: (swarm Pi-hole) `10.<<XX>>.10.255` and (FRITZ!Box) `10.<<XX>>.1.1`
  - Search domains: (swarm domain) `<<example.org>>` and `fritz.box`
- Profile setup
  - Your name: `New user`
  - Your server's name: `app-stable-1`
  - Username: `newuser`
  - Password: `newuser`
- Install OpenSSH server

Reboot

- Copy the SSH-key from the hypervisor (i.e., Ansible control system) to the VM (`ssh-copy-id newuser@10.69.10.0`).
- Login over SSH as `newuser`
- Run `sudo -s`
- Run `passwd` and set a safe root password
- Run `cat /home/newuser/.ssh/authorized_keys >> ~/.ssh/authorized_keys`

Disconnect

- Login over SSH as `root` (without password)
- Run `userdel -r newuser` (*you may have to kill running processes first*)
- Run `apt upgrade`

## Configure Docker engine

We'll need to configure the Docker explicitly in `/etc/docker/daemon.json` to use its internal `docker_gwbridge` network to connect to the pihole we'll deploy later. Docker usually extracts this information from the host's `/etc/resolve.conf`, but this breaks isolation and doesn't always work properly.

```json
{
  "dns": [ "172.18.0.1" ],
  "dns-search": [ "<<example.org>>", "fritz.box" ]
}
```

## Finalize Virtual Machine

Run on drone:

```bash
apt install qemu-guest-agent
rm /etc/machine-id
shutdown
```

Do the following in proxmox for this virtual machine:

- Enable the QEMU Guest Agent
- Convert to template

## Clone instances

- Create three linked clones:
  - VM ID: `6901000#` (10.**69.010.00#**; substitute as relevant)
  - Name: e.g., `drone-#`
- Add a data Hard disk to each:
  - Storage: `data-disk-#`
  - Disk size (GiB): `1792`
  - Backup: *unchecked*

Boot each instance (at old IP `10.69.10.0`) and run:

```bash
# Substitute for last IP address component
ID=1-254

rm /etc/machine-id
systemd-machine-id-setup

sed -i "s/10.69.10.0/10.69.10.$ID/g" /etc/netplan/00-installer-config.yaml
hostnamectl set-hostname "drone-$ID"
hostnamectl set-icon-name "vm"
hostnamectl set-deployment "development"
hostnamectl set-location "Neede"
netplan apply && exit

# You will be disconnected!
```

Reconnect over SSH to the new IP address
