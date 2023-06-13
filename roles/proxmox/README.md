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
#deb https://enterprise.proxmox.com/debian/pve bullseye pve-enterprise
deb http://download.proxmox.com/debian/pve bullseye pve-no-subscription
# Note the http instead of httpS!
```

!> See <https://pve.proxmox.com/wiki/Package_Repositories> for updated information.

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

Install CephFS via Proxmox for the sake of RAID 5. (Alternative is to run Ceph inside Docker nodes; see [Funky Penguin](https://geek-cookbook.funkypenguin.co.nz/ha-docker-swarm/shared-storage-ceph/) for more info.)

Configure Ceph as [One Node Cluster](https://docs.ceph.com/docs/mimic/rados/troubleshooting/troubleshooting-pg/#one-node-cluster):

- Add the line to `/etc/ceph/ceph.conf`:

```ini
[global]
...
osd_crush_chooseleaf_type = 0
```
- We need to change `type host` to `type osd` in the crushmap line `step chooseleaf firstn 0 type host`. This allows replication to any other osd (regardless of host). Run the following to do so automatically:

```sh
ceph osd getcrushmap -o crush_map_compressed
crushtool -d crush_map_compressed -o crush_map_decompressed
sed -i 's/step chooseleaf firstn 0 type host/step chooseleaf firstn 0 type osd/' crush_map_decompressed
crushtool -c crush_map_decompressed -o new_crush_map_compressed
ceph osd setcrushmap -i new_crush_map_compressed
```

- Create an Metadata Server.
- Create a CephFS
- Under Datacenter > Storage, add:
  - Type "RDB", named "distributed-ceph", for images, containers
  - Type "CephFS", named "distributed", for backups, images, snippets, templates

- Create one OSD per (4TB) data hard disk with **Encrypt OSD** *un*checked. If there's ever a problem with data corruption (been there), you don't want to lose all your data because the encryption keys are lost. (Ceph stores these in the "monitors")
- Create additional monitors on other hosts (if possible), following the official advice "Additional monitors are recommended. They can be created at any time in the Monitor tab."
