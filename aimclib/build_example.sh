#!/bin/bash

# ALPINE AIMC Library Build Script - C++17 and GCC 11
# Compatible with Ubuntu 22.04

echo "ALPINE AIMC Library Build Script - C++17 Version"
echo "================================================"

# Check if g++ is available
if ! command -v g++ &> /dev/null; then
    echo "Error: g++ is not installed or not in PATH"
    echo "Please install g++ for Ubuntu 22.04:"
    echo "  sudo apt update"
    echo "  sudo apt install g++"
    exit 1
fi

# Check GCC version
GCC_VERSION=$(g++ -dumpversion | cut -d. -f1)
if [ "$GCC_VERSION" -lt 11 ]; then
    echo "Warning: GCC version $GCC_VERSION detected. GCC 11+ recommended for C++17 features."
    echo "Consider upgrading: sudo apt install gcc-11 g++-11"
fi

echo "GCC version: $(g++ --version | head -n1)"
echo ""

# C++17 compilation flags for Ubuntu 22.04 with GCC 11
CXXFLAGS="-std=c++17 -Wall -Wextra -Wpedantic -O3 -march=native -mtune=native"
INCLUDES="-I."
LIBS=""

echo "Building with C++17 standard and optimizations..."
echo ""

# Build example.cc with checker (simulation mode)
echo "Building example with checker (simulation mode)..."
g++ $CXXFLAGS $INCLUDES -DUSE_CHECKER example.cc -o example_checker.out $LIBS

if [ $? -eq 0 ]; then
    echo "✓ example_checker.out built successfully"
else
    echo "✗ Failed to build example_checker.out"
    exit 1
fi

# Build example.cc without checker (hardware mode)
echo "Building example without checker (hardware mode)..."
g++ $CXXFLAGS $INCLUDES example.cc -o example_gem5.out $LIBS

if [ $? -eq 0 ]; then
    echo "✓ example_gem5.out built successfully"
else
    echo "✗ Failed to build example_gem5.out"
    exit 1
fi

echo ""
echo "Build completed successfully!"
echo ""
echo "To run the examples:"
echo "  ./example_checker.out  # Simulation mode"
echo "  ./example_gem5.out     # Hardware mode"
echo ""
echo "Build flags used: $CXXFLAGS"
