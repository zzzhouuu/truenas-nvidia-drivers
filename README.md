# TrueNAS 25.10 Nvidia GPU Driver

*Tip:* This repository uses Git LFS. Please navigate to the corresponding version folder and click the file to download the raw file; do not download the current repository’s zip archive via the Code button.

TrueNAS 25.10 now uses the NVIDIA open GPU kernel modules with the 570.172.08 driver. This enables TrueNAS to make use of NVIDIA Blackwell GPUs - the RTX 50-series and RTX PRO Blackwell cards - which many users have requested support for.

Unfortunately, what NVIDIA giveth, NVIDIA taketh away.

The NVIDIA 50-series Blackwell cards require the use of the new open GPU kernel module, but several of NVIDIA’s older generations of GPUs - including the Maxwell, Pascal, and Volta generations - lack the GPU System Processor (GSP) module on their silicon in order to leverage the open kernel module, and thus will no longer function. This includes the GTX 700-series, 900-GTX series, GTX 10-series, the Quadro M-series and P-series, and Tesla M-series and P-series cards.

This is to modify the official build parameters to remove the use of open GPU kernel module to be compatible with unsupported graphics cards.

`Warning: for testing purposes only`

## Overwriting the Existing Driver

You’ll need to replace the nvidia.raw file on your running TrueNAS system at /usr/share/truenas/sysext-extensions/nvidia.raw with the one you just compiled.

First, you need to make the /usr dataset writable:

If you checked Install NVIDIA Drivers on the settings panel

```shell
systemd-sysext unmerge
```

```shell
zfs set readonly=off boot-pool/ROOT/25.10.0/usr
```

Overwrite it!

```shell
cp nvidia.raw /usr/share/truenas/sysext-extensions/nvidia.raw
```

Then, set the /usr dataset back to read-only:

```shell
zfs set readonly=on boot-pool/ROOT/25.10.0/usr
```

After you’ve copied the file, simply run:

```shell
systemd-sysext merge
# Don't forget to restart docker service
systemctl restart docker
```

## Reference

- [TrueNAS Build Nvidia vGPU Driver extensions (systemd-sysext)](https://www.homelabproject.cc/posts/truenas/truenas-build-nvidia-vgpu-driver-extensions-systemd-sysext/)
- [NVIDIA Kernel Module Change in TrueNAS 25.10 - What This Means for You](https://forums.truenas.com/t/nvidia-kernel-module-change-in-truenas-25-10-what-this-means-for-you)
