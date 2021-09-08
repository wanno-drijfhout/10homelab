# Home Theater PC

We use a Raspberry Pi 4 as HTPC.

## Kodi

Install via OpenElec.

Install plugin [Retrospect](https://kodi.tv/addons/matrix/plugin.video.retrospect).

Configure maximum remote control via web interface (for Home Assistant).

## Bluetooth audio receiver

You can use the Raspberry as audio output device from a mobile phone (by connecting via bluetooth). This is useful for streaming music. A few steps have to be taken to configure this:

1. Log on via SSH to the Raspberry
2. `mount /flash -o rw,remount`
3. Modify `/flash/config.txt` with the following line:

       dtparam=audio=on

4. Go to LibreElec settings, services, and ensure Bluetooth is on.
5. Modify or create the file `/storage/.config/autostart.sh` with the following line:

       pactl load-module module-udev-detect

6. Reboot

Sources: [1](https://forum.kodi.tv/showthread.php?tid=154537&pid=1321799#pid1321799), [2](https://forum.libreelec.tv/thread/21318-libreelec-kodi-as-a-bluetooth-audio-receiver/?postID=144349#post144349)

See also: [3](https://wiki.libreelec.tv/configuration/pulseaudio#bluetooth-receiving)
