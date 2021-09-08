# Pi-hole

![Pi-hole](https://wp-cdn.pi-hole.net/wp-content/uploads/2016/12/Vortex-R.png ':size=96px') *Network-wide ad blocking via your own Linux hardware*

## Features

- [x] Advertisement and tracking blocker
- [x] Local DNS server
- [x] Overridden local `DOMAIN` name resolution to `SWARM_SHARED_IP` for performance and [distinguishing internal and external traffic](/inventories/network)
- [ ] IPv6 support

## Resources

- [Pi-hole](https://pi-hole.net/)
- [Pi-hole documentation](https://docs.pi-hole.net/)
- [FRITZ!Box (EN) - Pi-hole documentation](https://docs.pi-hole.net/routers/fritzbox/)
- [Pi-hole in a docker container](https://github.com/pi-hole/docker-pi-hole/)

## localdomain.conf

![localdomain.conf](./localdomain.conf.j2 ':include jinja2')

## webpassword.secret

*Generated.*

## docker-stack.yaml

![docker-stack.yaml](./docker-stack.yaml ':include')
