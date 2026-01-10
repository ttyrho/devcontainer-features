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


if [ "$(id --user)" -ne 0 ]; then
    echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi

source /etc/os-release

update_package_cache
install_packages gfortran
clean_package_cache

echo "GNU Fortran instaled"