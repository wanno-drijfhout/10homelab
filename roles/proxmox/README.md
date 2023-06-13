# Proxmox

## Prepare USB-stick with PVE

1. [Download](https://www.proxmox.com/en/downloads) the "Proxmox VE (x.y) ISO Installer".
2. [Write](http://pve.proxmox.com/wiki/Install_from_USB_Stick) the ISO image to USB using SUSE Studio ImageWriter or OSForencics USB installer.
3. Boot from USB stick.

## Install PVE

Install on the SSD.

Use network settings:

- FQDN: `<host>.<domain>` (*Note: this is the DHCP domain; e.g., `fritz.box`)
- IP address: `10.<<XX>>.1.10/16`
- Netmask: `255.255.0.0`
- Gateway: `10.<<XX>>.1.1`
- DNS Server: `10.<<XX>>.1.1` (*Note: this is the DHCP server IP; e.g., the FRITZ!Box)

Maximize the local SSD storage:

```bash
lvextend /dev/pve/data /dev/sda3
```

## Update packages

Rename `/etc/apt/sources.list.d/pve-enterprise.list` to `pve-no-subscription.list` and replace:

```
# deb https://enterprise.proxmox.com/debian buster pve-enterprise
deb http://download.proxmox.com/debian buster pve-no-subscription
```

Then, run:

```bash
apt update
apt install vim-scripts
apt dist-upgrade
```

## Enable automatic updates

[Full instructions](https://help.ubuntu.com/lts/serverguide/automatic-updates.html)

```bash
apt install unattended-upgrades apt-listchanges apticron
```

Edit `/etc/apt/apt.conf.d/50unattended-upgrades`:

```perl
Unattended-Upgrade::MinimalSteps "true";
Unattended-Upgrade::Mail "root";
```

## Create distributed/redundant storage

Install CephFS on the Hypervisor for the sake of RAID 5. Add all disks as OSDs (encrypted).

Configure Ceph as [One Node Cluster](https://docs.ceph.com/docs/mimic/rados/troubleshooting/troubleshooting-pg/#one-node-cluster):

- Add the line to `/etc/ceph/ceph.conf`:

```ini
[global]
...
osd_crush_chooseleaf_type = 0
```

The approach below will install Ceph via Proxmox. Alternative is to run Ceph inside Docker nodes; see [Funky Penguin](https://geek-cookbook.funkypenguin.co.nz/ha-docker-swarm/shared-storage-ceph/) for more info.

- Create one OSD per (4TB) data hard disk with **Encrypt OSD** checked

> If you created OSDs too early, you may need to repair `type host` to `type osd` in the crushmap according to [these instructions](https://linoxide.com/linux-how-to/hwto-configure-single-node-ceph-cluster/). This allows replication to any other osd (regardless of host).

- Create an Metadata Server.
- Create a CephFS
- Under Datacenter > Storage, add:
  - Type "RDB", named "distributed-ceph", for images, containers
  - Type "CephFS", named "distributed", for backups, images, snippets, templates
