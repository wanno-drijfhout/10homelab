# Pi-hole

![Pi-hole](https://wp-cdn.pi-hole.net/wp-content/uploads/2016/12/Vortex-R.png ':size=96px') *Network-wide ad blocking via your own Linux hardware*

We use Pi-hole primarily for its DNS service.

## Resources

- [Pi-hole](https://pi-hole.net/)
- [Pi-hole documentation](https://docs.pi-hole.net/)
- [Fritz!Box (EN) - Pi-hole documentation](https://docs.pi-hole.net/routers/fritzbox/)
- [Pi-hole in a docker container](https://github.com/pi-hole/docker-pi-hole/)

## localdomain.conf

![localdomain.conf](./localdomain.conf.j2 ':include jinja2')

## webpassword.secret

*Generated*

## docker-stack.yaml

![docker-stack.yaml](./docker-stack.yaml ':include')
