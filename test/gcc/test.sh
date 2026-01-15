#!/usr/bin/env bash
# Tests the GNU Compiler Collection installation.

source dev-container-features-test-lib

# Check the C/C++ compiler is available
check "C/C++ compiler (gcc) availability" gcc --version
check "C/C++ compiler (cc) availability" cc --version

reportResults