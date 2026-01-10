#!/usr/bin/env bash
# Installs the latest version of the Fortran Package Manager from the binary distribution.

set -e


update_package_cache() {
    case "${ID}" in
        debian|ubuntu)
            apt update --yes
        ;;
    esac
}


clean_package_cache() {
    case "${ID}" in
        debian|ubuntu)
            apt clean
        ;;
    esac
}


install_packages() {
    case "${ID}" in
        debian|ubuntu)
            apt install --yes --no-install-recommends "$@"
        ;;
    esac
}


# Downloads the binary file.
# Arguments:
#   - The URL of the binary file
#   - The name to be given to the downloaded binary file.
download_binary() {
    curl -fsSL "$1" > "$2"
}


# Verifies the downloaded binary matches the expected checksum.
# Arguments:
#   - The URL of the expected checksum
#   - The name of the downloaded binary file
verify_binary_checksum() {
    EXPECTED_CHECKSUM=`curl -fsSL "$1" | cut -d' ' -f1`
    ACTUAL_CHECKSUM=`openssl sha256 -r "$2" | cut -d' ' -f1`

    if [ ${EXPECTED_CHECKSUM} = ${ACTUAL_CHECKSUM} ]; then
        echo "Binary checksum successfully verified"
    else
        echo "Binary checksum mismatch. Expected: ${EXPECTED_CHECKSUM}. Actual: ${ACTUAL_CHECKSUM}."
        exit 1
    fi
}


# Installs the binary file to the desired location.
# Arguments:
#   - The name of the downloaded binary file.
#   - The directory where tyhe binary file should be installed in.
install_binary() {
    chmod +x "$1"
    mv "$1" "$2"/fpm
    export PATH="$2":${PATH}
}


if [ "$(id --user)" -ne 0 ]; then
  echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
  exit 1
fi

source /etc/os-release

update_package_cache
install_packages curl ca-certificates openssl
clean_package_cache

DOWNLOAD_URL=https://github.com/fortran-lang/fpm/releases/download/
BINARY_FILENAME=fpm-linux-x86_64-gcc-12
BINARY_URL=${DOWNLOAD_URL}/current/${BINARY_FILENAME}
CHECKSUM_URL=${BINARY_URL}.sha256

download_binary ${BINARY_URL} /tmp/${BINARY_FILENAME}
verify_binary_checksum ${CHECKSUM_URL} /tmp/${BINARY_FILENAME}
install_binary /tmp/${BINARY_FILENAME} /usr/local/bin

echo "Fortran Package Manager successfully instaled"