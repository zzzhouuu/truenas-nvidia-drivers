#!/usr/bin/env bash

version="25.10.2"
sha256="1d5c14049cd27f4bc7dd7eb1aab478c4e0af566dd3355a59c3ddad15997d1afc"

# download nvidia raw file
wget -O /tmp/nvidia.raw "https://truenas-drivers.zhouyou.info/${version}/nvidia.raw"

# verify the downloaded file
if echo "${sha256}  /tmp/nvidia.raw" | sha256sum -c -; then
  echo "SHA256 checksum verification passed."

  # disable nvidia support temporarily
  midclt call docker.update '{"nvidia": false}'
  systemd-sysext unmerge

  # install nvidia raw file
  zfs set readonly=off "$(zfs list -H -o name /usr)"
  mv /usr/share/truenas/sysext-extensions/nvidia.raw /usr/share/truenas/sysext-extensions/nvidia.raw.bak
  mv /tmp/nvidia.raw /usr/share/truenas/sysext-extensions/
  zfs set readonly=on "$(zfs list -H -o name /usr)"

  # enable nvidia support
  midclt call docker.update '{"nvidia": true}'

  echo "NVIDIA drivers installed successfully."
else
  echo "SHA256 checksum verification failed!"
  echo "Deleting invalid files..."

  rm -f /tmp/nvidia.raw
  exit 1
fi
