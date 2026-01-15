#!/usr/bin/env bash
# Installs the latest GNU Compiler Collection.

set -e


source ./scripts/output.sh


update_package_cache() {
    case "${ID}" in
        debian|ubuntu)
            info_msg "Updating package list"
            apt update --yes
        ;;
    esac
}


clean_package_cache() {
    case "${ID}" in
        debian|ubuntu)
            info_msg "Cleaning the package cache"
            apt clean
        ;;
    esac
}


install_packages() {
    case "${ID}" in
        debian|ubuntu)
            info_msg "Installing packages: $*"
            apt install --yes --no-install-recommends "$@"
        ;;
    esac
}


source /etc/os-release

case "${ID}" in
    debian|ubuntu)
    ;;
    *)
        error_msg "${ID}: Unsupported operating system"
        exit 1
    ;;
esac
    
if [ "$(id --user)" -ne 0 ]; then
  error_msg "Script must be run as root. Actual UID: $(id --user)"
  exit 1
fi

package_list=(gcc)

if [ ${INSTALLCPLUSPLUS} = "true" ]; then
    info_msg "Installing the GNU C++ frontend (g++)"
    package_list=("${package_list[@]}" g++)
fi

if [ ${INSTALLFORTRAN} = "true" ]; then
    info_msg "Installing the GNU Fortran compiler (gfortran)"
    package_list=("${package_list[@]}" gfortran)
fi

update_package_cache
install_packages "${package_list[@]}"
clean_package_cache

success_msg "GNU Compiler Collection installed"