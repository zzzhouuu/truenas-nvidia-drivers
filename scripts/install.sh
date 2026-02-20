#!/usr/bin/env bash

set -euo pipefail

# Get the current TrueNAS version (e.g., 25.10.1)
version=$(midclt call system.info | jq -r '.version')
if [[ -z "$version" || "$version" == "null" ]]; then
    echo "ERROR: Failed to detect TrueNAS version" >&2
    exit 1
fi

echo "Detected TrueNAS version: ${version}"

base_url="https://truenas-drivers.zhouyou.info/${version}"
raw_file="/tmp/nvidia.raw"
sha256_file="/tmp/nvidia.raw.sha256"

# cleanup function
cleanup() {
    rm -f "${raw_file}" "${sha256_file}"
}
trap cleanup EXIT

echo "Downloading NVIDIA drivers ${version}..."

# Check if the remote file exists (to avoid continuing after a 404 error).
if ! wget --spider -q "${base_url}/nvidia.raw"; then
    echo "ERROR: Driver not found for version ${version}" >&2
    echo "Available versions may differ. Check: https://truenas-drivers.zhouyou.info/index.html" >&2
    exit 1
fi

# download nvidia raw file and sha256 checksum
wget -q --show-progress -O "${raw_file}" "${base_url}/nvidia.raw"
wget -q --show-progress -O "${sha256_file}" "${base_url}/nvidia.raw.sha256"

# verify the downloaded file
echo "Verifying SHA256 checksum..."
if ! sha256sum -c "${sha256_file}"; then
    echo "ERROR: SHA256 checksum verification failed!" >&2
    exit 1
fi

echo "SHA256 checksum verification passed."

# disable nvidia support temporarily
echo "Disabling NVIDIA support..."
midclt call docker.update '{"nvidia": false}' > /dev/null
systemd-sysext unmerge

# install nvidia raw file
echo "Installing NVIDIA drivers..."
zfs_dataset=$(zfs list -H -o name /usr)

zfs set readonly=off "${zfs_dataset}"

# backup existing driver if present
if [[ -f /usr/share/truenas/sysext-extensions/nvidia.raw ]]; then
    mv /usr/share/truenas/sysext-extensions/nvidia.raw \
       /usr/share/truenas/sysext-extensions/nvidia.raw.bak
fi

mv "${raw_file}" /usr/share/truenas/sysext-extensions/nvidia.raw

zfs set readonly=on "${zfs_dataset}"

# enable nvidia support
echo "Enabling NVIDIA support..."
systemd-sysext merge
midclt call docker.update '{"nvidia": true}' > /dev/null

echo "NVIDIA drivers installed successfully."