#!/usr/bin/env bash
# Installs the latest version of the Fortran Package Manager from the binary distribution.

set -e


source ./scripts/output.sh


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
        msg yellow "[I] Binary checksum successfully verified"
    else
        msg red "[E] Binary checksum mismatch. Expected: ${EXPECTED_CHECKSUM}. Actual: ${ACTUAL_CHECKSUM}."
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


source /etc/os-release

case "${ID}" in
    debian|ubuntu)
    ;;
    *)
        msg red "$[E] {ID}: Unsupported operating system"
        exit 1
    ;;
esac
    
if [ "$(id --user)" -ne 0 ]; then
  msg red "[E] Script must be run as root. Actual UID: $(id --user)"
  exit 1
fi

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

msg green "Fortran Package Manager successfully installed"