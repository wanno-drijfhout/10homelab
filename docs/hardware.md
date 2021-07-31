# Hardware management

## Update microcode

[Instructions](https://www.cyberciti.biz/faq/install-update-intel-microcode-firmware-linux/)

Add to `/etc/apt/sources.list`:

```
deb http://ftp.de.debian.org/debian buster main non-free
```

Then, run

```bash
apt update
apt install intel-microcode
reboot
dmesg | grep 'microcode'
```

The above should say 'microcode updated' if appropriate. You can also check for CPU vulnerabilities again; they should be "Mitigated"

### Check for CPU vulnerabilities

```bash
for f in /sys/devices/system/cpu/vulnerabilities/*; do echo "${f##*/} -" $(cat "$f"); done
```

Before updating microcode:

```
itlb_multihit - KVM: Mitigation: Split huge pages
l1tf - Mitigation: PTE Inversion; VMX: conditional cache flushes, SMT disabled
mds - Vulnerable: Clear CPU buffers attempted, no microcode; SMT disabled
meltdown - Mitigation: PTI
spec_store_bypass - Vulnerable
spectre_v1 - Mitigation: usercopy/swapgs barriers and __user pointer sanitization
spectre_v2 - Mitigation: Full generic retpoline, STIBP: disabled, RSB filling
tsx_async_abort - Vulnerable: Clear CPU buffers attempted, no microcode; SMT disabled
```

After updating microcode:

```
itlb_multihit - KVM: Mitigation: Split huge pages
l1tf - Mitigation: PTE Inversion; VMX: conditional cache flushes, SMT disabled
mds - Mitigation: Clear CPU buffers; SMT disabled
meltdown - Mitigation: PTI
spec_store_bypass - Mitigation: Speculative Store Bypass disabled via prctl and seccomp
spectre_v1 - Mitigation: usercopy/swapgs barriers and __user pointer sanitization
spectre_v2 - Mitigation: Full generic retpoline, IBPB: conditional, IBRS_FW, STIBP: disabled, RSB filling
tsx_async_abort - Mitigation: Clear CPU buffers; SMT disabled
```

## Enable sensors

[Instructions](http://askubuntu.com/a/15833)

```bash
apt install lm-sensors hddtemp
sensors-detect
service kmod start
sensors
# hddtemp /dev/sd*
```

## Enable disk monitoring

```bash
apt install smartmontools
smartctl --smart=on --offlineauto=on --saveauto=on /dev/sda
smartctl --smart=on --offlineauto=on --saveauto=on /dev/sdb
smartctl --smart=on --offlineauto=on --saveauto=on /dev/sdc
smartctl --smart=on --offlineauto=on --saveauto=on /dev/sdd
```

## Enable hardware monitoring

Install [mcelog](http://mcelog.org/installation.html)
