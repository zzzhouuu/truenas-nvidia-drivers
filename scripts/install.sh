version="25.10.1"

# disable nvidia support temporarily
midclt call docker.update '{"nvidia": false}'

# download nvidia raw file
wget -O /tmp/nvidia.raw "https://github.com/zzzhouuu/truenas-nvidia-drivers/raw/refs/heads/main/${version}/nvidia.raw"

# install nvidia raw file
zfs set readonly=off "$(zfs list -H -o name /usr)"
mv /usr/share/truenas/sysext-extensions/nvidia.raw /usr/share/truenas/sysext-extensions/nvidia.raw.bak
mv /tmp/nvidia.raw /usr/share/truenas/sysext-extensions/
zfs set readonly=on "$(zfs list -H -o name /usr)"

# enable nvidia support
midclt call docker.update '{"nvidia": true}'
