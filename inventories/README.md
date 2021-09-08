# Inventories

To get started with 10homelab, you will need the following:

- A public IPv4 address
- A public domain name
- A fixed internal IP CIDR `10.XX.0.0/16` (so, choose a static number for X, like your house street number)

!> Throughout the documentation, you will see references to `10.69.y.z`; substitute the `69` with your own number.

## hosts

You must create an Ansible host file to configure your deployment. For example, you may create a file `inventories/default/hosts` with the following content:

![default/hosts](default/hosts.example ':include')

Adapt the content as necessary and desired. You may also replace `default` by a stage name (e.g., `stable`, `experimental`, `v2` or whatever).

## Features

![features](_features.md ':include')
