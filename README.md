# TrueNAS Nvidia Driver Build

A build framework for TrueNAS SCALE.

## Usage

```bash
wget -O /tmp/nvidia.raw https://truenas-drivers.zhouyou.info/25.10.7/nvidia.raw

systemd-sysext unmerge
zfs set readonly=off "$(zfs list -H -o name /usr)"
cp /tmp/nvidia.raw /usr/share/truenas/sysext-extensions/nvidia.raw
zfs set readonly=on "$(zfs list -H -o name /usr)"
systemd-sysext merge
systemctl restart docker
```

## Patches

- remove nvidia open source kernel module

## Artifacts

The build artifacts have been uploaded to the Cloudflare R2 storage. Public access link: [truenas-drivers](https://truenas-drivers.zhouyou.info/index.html)

example:

```shell
# 25.10.6
wget -O /tmp/nvidia.raw https://truenas-drivers.zhouyou.info/25.10.6/nvidia.raw

# 25.10.7
wget -O /tmp/nvidia.raw https://truenas-drivers.zhouyou.info/25.10.7/nvidia.raw

# 27.0.0-RC.1
wget -O /tmp/nvidia.raw https://truenas-drivers.zhouyou.info/27.0.0-RC.1/nvidia.raw
```

### tree structure of the artifacts

```shell
.
├── 25.10.6
│   ├── TrueNAS-SCALE-25.10.6.update
│   ├── TrueNAS-SCALE-25.10.6.update.sha256
│   ├── nvidia.raw
│   └── nvidia.raw.sha256
├── 25.10.7
│   ├── TrueNAS-SCALE-25.10.7.update
│   ├── TrueNAS-SCALE-25.10.7.update.sha256
│   ├── nvidia.raw
│   └── nvidia.raw.sha256
├── 27.0.0-RC.1
│   ├── TrueNAS-SCALE-27.0.0-RC.1.update
│   ├── TrueNAS-SCALE-27.0.0-RC.1.update.sha256
│   ├── nvidia.raw
│   └── nvidia.raw.sha256
```

## Reference

- [TrueNAS Build Nvidia vGPU Driver extensions (systemd-sysext)](https://www.homelabproject.cc/posts/truenas/truenas-build-nvidia-vgpu-driver-extensions-systemd-sysext/)
- [NVIDIA Kernel Module Change in TrueNAS 25.10 - What This Means for You](https://forums.truenas.com/t/nvidia-kernel-module-change-in-truenas-25-10-what-this-means-for-you)
