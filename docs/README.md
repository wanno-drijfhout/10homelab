# 10homelab

The "10homelab" project configures a home server, sufficiently secure and maintainable for personal use.

See our documentation on:

- [Introduction](./introduction.md)
- [Installing hypervisor](./proxmox.md)
- [Hardware management](./hardware.md)
- [Administration](./administration.md)

## Features

- Deployment automation **Ansible**
- Hypervisor **Proxmox**
- Distributed storage platform **Ceph** (built in Promox)
- Distributed computing platform **Docker Swarm**
- Home network configuration for local **CIDR** (10.x.y.z/16) and **domain**
- Default application stacks:
  - Reverse proxy **Traefik** (includes **Let's Encrypt** SSL certificates)
  - DNS and adblocker **Pi-hole** (includes local IP reroute for public domain)
  - Docker management tool **Portainer**
  - Stack dashboard **Organizr**
  - Groupware **Nextcloud**

## Principles

We balance the following principles:

- Reasonably **simple**
  - convention over configuration, defaults, consistency
- Reasonably **secure**
  - auto-generated admin-accounts, no security hacks, but no active hardening
- Reasonably **stable**
  - separate inventories per stage (stable, experimental), trust automatic upgrades

## Inspiration & resources

For further reading, check out:

- [r/Homelab](https://www.reddit.com/r/homelab/)
- [Funky Penguin](https://geek-cookbook.funkypenguin.co.nz/)
- [Test voor moderne Internetstandaarden](https://internet.nl/)
