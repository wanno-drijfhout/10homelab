# Home Assistant Operating System

## Installation

- Download and install HAOS (hassio) on a Raspberry Pi 4 SD-card.
- Once installed, create your user account in Home Assistant via the web interface

---

## Enable ssh

*We want SSH to log on remotely.*

See [these instructions](https://smarthomepursuits.com/connect-to-home-assistant-ssh/)

### Generate a personal SSH key

```sh
ssh-keygen -t ed25519 -C "<you>@homeassistant"
```

### Enable "Advanced mode" for your profile

### Install "Terminal & SSH" addon from the store

### Configure the SSH addon

- Add the public key you generated.
- Set the port to `22`.

---

## Reverse proxy server

*We want to code-name our devices and route service domains via a proxy (and SSL) running at the HA.*

### Install Traefik

- Check [these instructions](https://github.com/alex3305/home-assistant-addons/blob/master/traefik/DOCS.md) to install Traefik.
- Set-up the SSL environment variables and configuration in the add-on settings
- Set-up the environment variables `DOMAIN=example.org` and `HOSTNAME_HA=homeassistant.local` in the add-on settings (but changed accordingly)
- Put your (private key) files in `/config/traefik/{domainprovider.key}`
- Copy and paste [config-traefik](config-traefik) files to `/config/traefik/*.yaml` (note the `yaml` extension).

### Configure Home Assistant for reverse proxying

- Add to `/config/configuration.yaml`:

    ```yaml
    http:
    ip_ban_enabled: true
    login_attempts_threshold: 5
    use_x_forwarded_for: true
    trusted_proxies:
        - 127.0.0.1
        - 10.69.1.27
        - 172.30.33.0/24 # Private network
    ```

## DNS server (and AdGuard)

*We want a DNS server to route our local domain. We want AdGuard (like pi-hole) because it filters DNS queries.*

### Set Static IP

- Settings → System → Network → Configure network interfaces → Your Interface → IPv4 → Static
  - IP address/netmask: 10.<X>.1.27/16

### Configure AdGuard for domain

- Settings > DNS settings
  - Replace `https://dns10.quad9.net/dns-query` by `10.<X>.1.1` (Fritz!Box)
  - Enable `Enable conversion of client hostnames`
- Filters > DNS rewrites
  - Add `*.<DOMAIN>` to be rewritten to `10.69.1.27` (for optimization)

### Configure Home Assistant for domain

- Settings → System → Network → Configure network interfaces
  - Set "Host name"
- Settings → System → Network → Home Assistant URL
  - Internet: `https://home.<DOMAIN>/`
  - Local network: `https://home.<DOMAIN>/` (uncheck "Automatic")
- Settings → System → Network → Configure network interfaces → Your Interface → IPv4 → Static
  - FIXME: this prevents add-ons from being installed! DNS server: `10.69.1.27` (to make use of AdGuard in HA itself)

---

## Configure network storage

- On Fritz!Box
  - Connect external HDD device
  - Configure: Home Network > USB/Storage > under Home Network sharing:
    - Check "Access via network drive (SMB) Enabled"
    - Set name `NAS`
    - Click `Apply`
- Connect on local machine to `\\10.<X>.1.1\NAS` and create subfolders:
  - `FRITZ` (already existed)
  - `BACKUPS` (backups)
    - `homeassistant`
  - `SHARED` (storage that is shared and accessible by all HA add-ons)
    - `nextcloud` (big data needs external storage)
    - `www` (websites)
  - `MEDIA_OWN` (external drive; owned media)
    - `Music`
    - `Movies`
    - `Series`
    - `Anime`
    - `Books`
  - `MEDIA_DOWN` (external drive; downloaded media -- not backed up)
    - `Music`
    - `Movies`
    - `Series`
    - `Anime`
    - `Books`
- Create service accounts for `homeassistant` and other devices (e.g., Nvidia shield) with access to the NAS and limited rights to directories
- Configure **large (external) storage device** attached to FritzBox
  - In Home Assistant Settings > System > Storage > Add network storage for...
    - NAS_BACKUPS (backup) -- only if on external storage device
    - NAS_MEDIA (media)
    - NAS_SERVICE (share)
- Later: ~Configure in Nvidia Shield for media~

---

## Install OneDrive backup

*If we have all that storage, we can just as well use it for back-ups.*

- Install the [OneDrive back-up add-on](https://github.com/lavinir/hassio-onedrive-backup)
- Configure the add-on:
  - Set "Number of local backups": `1`
  - Set "Number of OneDrive backups": `8`
  - Enable "Monitor all local backups"
  - Enable "Ignore upgrade backups"
  - "Backup password": **consider not having one** (the .tar.gz files cannot be properly opened by 7zip afterwards, making you fully dependent on decrypting it manually later)
  - Enable "Exclude media folder"
  - Set "File Sync Paths": `/media/media_own`
  - Enable "Remove deleted files during File Sync"
  - "Allowed hours": 0-6
  - "Backup instance name": *FQDN of home assistant*

## Install MariaDb

- Install [MariaDb as HA add-on](https://github.com/home-assistant/addons/blob/master/mariadb/DOCS.md)
- Configure add-on with accounts and databases for:
  - `homeassistant`
- Configure HomeAssistant to use MariaDb for [recording data](https://github.com/home-assistant/addons/blob/master/mariadb/DOCS.md#home-assistant-configuration):

  ```yaml
  recorder:
    db_url: mysql://homeassistant:<PASSWORD>@core-mariadb/homeassistant?charset=utf8mb4
    commit_interval: 60
    # Increasing this will reduce disk I/O and may prolong disk (SD card) lifetime with the trade-off being that the database will lag (the logbook and history will not lag, because the changes are streamed to them immediately).
  ```

## Install Portainer

- Install [Portainer as HA add-on](https://github.com/alexbelgium/hassio-addons/wiki/portainer).
- Choose a random password

## Install Nextcloud

- Install [Nextcloud as HA add-on](https://github.com/alexbelgium/hassio-addons/tree/master/nextcloud)
- Configure add-on; change the following options:

  ```yaml
  OCR: true
  OCRLANG: nld,eng
  trusted_domains: nextcloud.<YOUR-DOMAIN.COM>,<DEVICENAME>.local,127.0.0.1,10.69.1.27,172.30.33.0/24
  TZ: Europe/Amsterdam
  disable_updates: true
  ```

- Configure add-on; disable HTTPS port and enable HTTP port (`8082`)
- Start Nextcloud; check the logs for information about how to configure databases in MariaDB
- Install plugins from app store
  - Calendar
  - Contacts
  - Mail
  - Notes
  - Tasks
  - External storage support
  - Two-Factor TOTP Provider
- For every user, configure external storage using their own credentials:
  - NAS via SMB/CIFS

### Configure reverse proxies

- Open a console on the nextcloud container with Portainer. (*We [need](https://github.com/alexbelgium/hassio-addons/issues/852) Portainer; see further below to install Portainer, then come back here.*)
- Edit `/data/config/www/nextcloud/config/config.php` to configure [reverse proxy](https://docs.nextcloud.com/server/27/admin_manual/configuration_server/reverse_proxy_configuration.html#multiple-domains-reverse-ssl-proxy). Also fix warnings shown in the admin interface of Nextcloud.

  ```php
  <?php
  $CONFIG = array (
    'trusted_proxies'   => ['172.30.33.0/24'],
    'overwritehost'     => 'nextcloud.<YOUR-DOMAIN.COM>',
    'overwriteprotocol' => 'https',
    'overwrite.cli.url' => 'https://nextcloud.<YOUR-DOMAIN.COM>',

    'default_phone_region' => 'nl',
  );
  ```

---

## Install HACS

- [Download](https://hacs.xyz/docs/setup/download) HACS
- [Enable](https://hacs.xyz/docs/configuration/basic) HACS integration
