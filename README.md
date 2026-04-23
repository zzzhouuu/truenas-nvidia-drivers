# TrueNAS Nvidia Driver Build

A build framework for TrueNAS SCALE.

## Usage

```bash
wget -O /tmp/nvidia.raw https://truenas-drivers.zhouyou.info/25.10.2/nvidia.raw

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
# 25.10.1
wget -O /tmp/nvidia.raw https://truenas-drivers.zhouyou.info/25.10.1/nvidia.raw

# 25.10.2
wget -O /tmp/nvidia.raw https://truenas-drivers.zhouyou.info/25.10.2/nvidia.raw
```

### tree structure of the artifacts

```shell
.
├── 25.10.1
│   ├── TrueNAS-SCALE-25.10.1.update
│   ├── TrueNAS-SCALE-25.10.1.update.sha256
│   ├── build.log
│   ├── manifest.json
│   ├── nvidia.raw
│   └── nvidia.raw.sha256
├── 25.10.2.1
│   ├── TrueNAS-SCALE-25.10.2.1.update
│   ├── TrueNAS-SCALE-25.10.2.1.update.sha256
│   ├── build.log
│   ├── manifest.json
│   ├── nvidia.raw
│   └── nvidia.raw.sha256
├── 25.10.3
│   ├── TrueNAS-SCALE-25.10.3.update
│   ├── TrueNAS-SCALE-25.10.3.update.sha256
│   ├── build.log
│   ├── manifest.json
│   ├── nvidia.raw
│   └── nvidia.raw.sha256
├── 26.0.0-BETA.1
│   ├── TrueNAS-26.0.0-BETA.1.update
│   ├── TrueNAS-26.0.0-BETA.1.update.sha256
│   ├── nvidia.raw
│   └── nvidia.raw.sha256
```

## Reference

- [TrueNAS Build Nvidia vGPU Driver extensions (systemd-sysext)](https://www.homelabproject.cc/posts/truenas/truenas-build-nvidia-vgpu-driver-extensions-systemd-sysext/)
- [NVIDIA Kernel Module Change in TrueNAS 25.10 - What This Means for You](https://forums.truenas.com/t/nvidia-kernel-module-change-in-truenas-25-10-what-this-means-for-you)
