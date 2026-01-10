#!/usr/bin/env bash
# Tests the installation of the Fortran Package Manager.

set -e

source dev-container-features-test-lib

check "Command availability" gfortran --version

reportResults