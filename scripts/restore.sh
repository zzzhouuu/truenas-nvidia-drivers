#!/usr/bin/env bash

# disable nvidia support temporarily
midclt call docker.update '{"nvidia": false}'
systemd-sysext unmerge

# restore nvidia raw file
zfs set readonly=off "$(zfs list -H -o name /usr)"
rm -fr /usr/share/truenas/sysext-extensions/nvidia.raw
mv /usr/share/truenas/sysext-extensions/nvidia.raw.bak /usr/share/truenas/sysext-extensions/nvidia.raw
zfs set readonly=on "$(zfs list -H -o name /usr)"

# enable nvidia support
midclt call docker.update '{"nvidia": true}'
