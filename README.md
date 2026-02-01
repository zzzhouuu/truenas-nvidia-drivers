# TrueNAS Nvidia Driver Build

A build framework for TrueNAS SCALE.

## Usage

```bash
systemd-sysext unmerge
zfs set readonly=off "$(zfs list -H -o name /usr)"
cp nvidia.raw /usr/share/truenas/sysext-extensions/nvidia.raw
zfs set readonly=on "$(zfs list -H -o name /usr)"
systemd-sysext merge
systemctl restart docker
```

## Patches

- remove nvidia open source kernel module

## Reference

- [TrueNAS Build Nvidia vGPU Driver extensions (systemd-sysext)](https://www.homelabproject.cc/posts/truenas/truenas-build-nvidia-vgpu-driver-extensions-systemd-sysext/)
- [NVIDIA Kernel Module Change in TrueNAS 25.10 - What This Means for You](https://forums.truenas.com/t/nvidia-kernel-module-change-in-truenas-25-10-what-this-means-for-you)
