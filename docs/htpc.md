# Home Theater PC (Raspberry Pi)

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

6. Create a file called `/storage/.kodi/userdata/bluetooth.py` with the following lines:

    ```python
    import os, subprocess, xbmc
    # Perform the below shell command. This assigns the bluetooth device as a default source for Kodi
    os.system("pactl set-default-source `pactl list short sources | grep -i blue | awk {'print $2 '}`")
    # Assign the output of the shell command to BT_NAME (Bluetooth Name)
    BT_NAME = subprocess.check_output("pactl list sources | grep -i bluetooth.protocol -A 1 | awk 'FNR==2{print $3}'", shell=True)
    # If the variable is not empty, create a KODI dialog showing the name of the bluetooth device.
    if BT_NAME:
      xbmc.executebuiltin("Notification(Bluetooth,Activated %s,3000)" % BT_NAME)
      os.system("pactl unload-module module-loopback")
      os.system("pactl load-module module-loopback latency_msec=1000")
    # If the variable is empty, create a KODI dialog showing no bluetooth device found.
    else:
      xbmc.executebuiltin("Notification(Bluetooth,No Blutooth Device Found,3000)")
    ```

7. Modify or create the file `/storage/.kodi/userdata/keymaps/gen.xml` with the following lines (NOTE Modify Key Id as appropriate. Recommend using the "Keymap Editor" add-on to find the key id):

    ```xml
    <keymap>
        <global>
            <keyboard>
                <key id="61952">RunScript(special://masterprofile/bluetooth.py)</key>
            </keyboard>
        </global>
    </keymap>
    ```

1. Reboot


Sources: [1](https://forum.kodi.tv/showthread.php?tid=154537&pid=1321799#pid1321799), [2](https://forum.libreelec.tv/thread/21318-libreelec-kodi-as-a-bluetooth-audio-receiver/?postID=144349#post144349)