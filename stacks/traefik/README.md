# Traefik

![Traefik](https://doc.traefik.io/traefik/assets/images/logo-traefik-proxy-logo.svg ':size=96px') *[Traefik proxy] is simplify networking complexity while designing, deploying, and operating applications.*

## Features

- [x] HTTP(S) reverse proxy for Docker swarm containers
- [x] Let's Encrypt certificate management
- [x] [Distinguish internal and external traffic](/inventories/network)
- [ ] [Forward authentication and Single Sign-On](https://github.com/wanno-drijfhout/10homelab/issues/11)
- [ ] [Secure MQTT proxy](https://github.com/wanno-drijfhout/10homelab/issues/37)

## Resources

- [Traefik proxy]
- [Traefik proxy documentation]
- [Let's Encrypt]
- [Onboarding Your Customers with Let's Encrypt and ACME]

[Traefik proxy]: https://traefik.io/traefik/
[Traefik proxy documentation]: https://doc.traefik.io/traefik/
[Let's Encrypt]: https://letsencrypt.org/
[Onboarding Your Customers with Let's Encrypt and ACME]: https://letsencrypt.org/2019/10/09/onboarding-your-customers-with-lets-encrypt-and-acme.html

## docker-stack.yaml

Traefik "routers" will accept requests from all entry points, by default. You should specifically add labels to Docker stacks like: `"traefik.http.routers.$STACK-$SERVICE.entryPoints=web,websecure"`

![docker-stack.yaml](./docker-stack.yaml ':include')
