#!/usr/bin/env bash
set -euo pipefail

# 解析命令行参数
USE_IPV4=false
while [[ $# -gt 0 ]]; do
    case "$1" in
        -4|--ipv4)
            USE_IPV4=true
            shift
            ;;
        -h|--help)
            cat << 'EOF'
Usage: $0 [OPTIONS]

Options:
  -4, --ipv4    Force wget to use IPv4 only
  -h, --help    Show this help message

Environment Variables:
  FORCE_IPV4=1  Force IPv4 only (alternative to -4 flag)

Examples:
  $0                    # Normal download (IPv4/IPv6 auto)
  $0 -4                 # Force IPv4 only
  FORCE_IPV4=1 $0       # Force IPv4 using environment variable
EOF
            exit 0
            ;;
        *)
            echo "Unknown option: $1" >&2
            echo "Use -h or --help for usage information" >&2
            exit 1
            ;;
    esac
done

# 根据参数设置 wget 选项（命令行参数优先于环境变量）
WGET_OPTS=""
if [[ "$USE_IPV4" == true ]]; then
    WGET_OPTS="-4"
    echo "IPv4-only mode enabled (via command line)"
elif [[ "${FORCE_IPV4:-}" == "1" ]]; then
    WGET_OPTS="-4"
    echo "IPv4-only mode enabled (via environment variable)"
fi

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
if ! wget ${WGET_OPTS} --spider -q "${base_url}/nvidia.raw"; then
    echo "ERROR: Driver not found for version ${version}" >&2
    echo "Available versions may differ. Check: https://truenas-drivers.zhouyou.info/index.html" >&2
    exit 1
fi

# download nvidia raw file and sha256 checksum
wget ${WGET_OPTS} -q --show-progress -O "${raw_file}" "${base_url}/nvidia.raw"
wget ${WGET_OPTS} -q --show-progress -O "${sha256_file}" "${base_url}/nvidia.raw.sha256"

# verify the downloaded file
echo "Verifying SHA256 checksum..."
expected_hash=$(tr -d '\n\r ' < "${sha256_file}")
actual_hash=$(sha256sum "${raw_file}" | awk '{print $1}')

if [[ "${expected_hash}" != "${actual_hash}" ]]; then
    echo "ERROR: SHA256 checksum verification failed!" >&2
    echo "Expected: ${expected_hash}" >&2
    echo "Actual:   ${actual_hash}" >&2
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
