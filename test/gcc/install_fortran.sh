#!/usr/bin/env bash
# Tests the GNU Compiler Collection installation.

source dev-container-features-test-lib

# Check the C/C++ compiler is available
check "C/C++ compiler (gcc) is available" gcc --version
check "C/C++ compiler (cc) is available" cc --version

# Chec the GNU Fortran compiler is available
check "Fortran compiler (gfortran) availability" gfortran --version

reportResults