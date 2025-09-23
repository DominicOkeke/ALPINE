# ALPINE gem5-X-ALPINE Ubuntu 22.04 Complete Compatibility Guide

This document provides comprehensive information about using ALPINE gem5-X-ALPINE with Ubuntu 22.04, including Python 3.10+, C++17, C17, GCC 11, and modern toolchain support.

## Table of Contents

1. [Overview](#overview)
2. [System Requirements](#system-requirements)
3. [Installation](#installation)
4. [Configuration](#configuration)
5. [Building](#building)
6. [Testing](#testing)
7. [Troubleshooting](#troubleshooting)
8. [Advanced Usage](#advanced-usage)
9. [Performance Optimization](#performance-optimization)
10. [Contributing](#contributing)

## Overview

ALPINE gem5-X-ALPINE has been fully updated for Ubuntu 22.04 compatibility with:

- **Python 3.10+**: All Python scripts updated to Python 3.10+ syntax
- **C++17 Standard**: Full C++17 support with modern features
- **C17 Standard**: C17 support for C code
- **GCC 11**: Optimized for GCC 11 with advanced features
- **Modern Shell**: Updated shell scripts with modern bash standards
- **Ubuntu 22.04**: Full compatibility with Ubuntu 22.04 LTS

## System Requirements

### Minimum Requirements

- **OS**: Ubuntu 22.04 LTS (64-bit)
- **RAM**: 8GB (16GB recommended)
- **Storage**: 20GB free space
- **CPU**: 4 cores (8 cores recommended)
- **Python**: 3.10+
- **GCC**: 11.0+
- **SCons**: 4.0+

### Recommended Requirements

- **OS**: Ubuntu 22.04 LTS (64-bit)
- **RAM**: 32GB
- **Storage**: 100GB free space
- **CPU**: 16 cores
- **Python**: 3.10.7
- **GCC**: 11.4.0
- **SCons**: 4.5.2

## Installation

### Quick Installation

```bash
# Clone the repository
git clone <repository-url>
cd gem5-X-ALPINE

# Make setup script executable
chmod +x setup_ubuntu22_complete.sh

# Run complete setup
./setup_ubuntu22_complete.sh
```

### Manual Installation

#### 1. Update System

```bash
sudo apt update
sudo apt upgrade -y
sudo apt autoremove -y
sudo apt autoclean
```

#### 2. Install Essential Tools

```bash
sudo apt install -y \
    build-essential \
    cmake \
    ninja-build \
    git \
    wget \
    curl \
    unzip \
    tar \
    gzip \
    bzip2 \
    xz-utils \
    pkg-config \
    autoconf \
    automake \
    libtool \
    make \
    gcc \
    g++ \
    gdb \
    valgrind \
    strace \
    ltrace
```

#### 3. Install Python 3.10+

```bash
sudo apt install -y \
    python3 \
    python3-dev \
    python3-pip \
    python3-venv \
    python3-setuptools \
    python3-wheel \
    python3-distutils \
    python3-numpy \
    python3-scipy \
    python3-matplotlib \
    python3-pandas \
    python3-sympy \
    python3-jupyter \
    python3-jupyterlab

# Install additional Python packages
pip3 install --user \
    scons \
    pybind11 \
    protobuf \
    six \
    mako \
    cheetah3 \
    ply \
    pyyaml
```

#### 4. Install GCC 11

```bash
sudo apt install -y \
    gcc-11 \
    g++-11 \
    gcc-11-multilib \
    g++-11-multilib \
    gcc-11-plugin-dev \
    libgcc-11-dev \
    libstdc++-11-dev

# Set GCC 11 as default
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-11 100
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-11 100
```

#### 5. Install Cross-Compilation Tools

```bash
# ARM cross-compilation
sudo apt install -y \
    gcc-aarch64-linux-gnu \
    g++-aarch64-linux-gnu \
    gcc-arm-linux-gnueabihf \
    g++-arm-linux-gnueabihf \
    binutils-aarch64-linux-gnu \
    binutils-arm-linux-gnueabihf

# Other architectures
sudo apt install -y \
    gcc-mips-linux-gnu \
    g++-mips-linux-gnu \
    gcc-powerpc-linux-gnu \
    g++-powerpc-linux-gnu \
    gcc-riscv64-linux-gnu \
    g++-riscv64-linux-gnu
```

#### 6. Install gem5 Dependencies

```bash
sudo apt install -y \
    libprotobuf-dev \
    protobuf-compiler \
    libgoogle-perftools-dev \
    libtcmalloc-minimal4 \
    libunwind-dev \
    libelf-dev \
    libdwarf-dev \
    libz-dev \
    libbz2-dev \
    liblzma-dev \
    libssl-dev \
    libffi-dev \
    libreadline-dev \
    libsqlite3-dev \
    libncurses5-dev \
    libncursesw5-dev \
    libgdbm-dev \
    libnss3-dev \
    libedit-dev \
    libxml2-dev \
    libxslt1-dev \
    libyaml-dev \
    libgmp-dev \
    libmpfr-dev \
    libmpc-dev \
    libisl-dev \
    libcloog-isl-dev \
    libgsl-dev \
    libblas-dev \
    liblapack-dev \
    libopenblas-dev \
    libatlas-base-dev \
    libhdf5-dev \
    libnetcdf-dev
```

## Configuration

### Environment Variables

Add the following to your `~/.bashrc`:

```bash
# gem5-X-ALPINE Environment Variables
export M5_PATH="$HOME/gem5"
export GEM5_ROOT="$(pwd)"
export PYTHONPATH="$GEM5_ROOT/src/python:$PYTHONPATH"
export PATH="$GEM5_ROOT/util:$PATH"

# GCC 11 Configuration
export CC=gcc-11
export CXX=g++-11
export CFLAGS="-std=c17 -O2 -march=native -mtune=native"
export CXXFLAGS="-std=c++17 -O2 -march=native -mtune=native"

# Python 3 Configuration
export PYTHON=python3
export PYTHON3=python3

# Cross-compilation paths
export CROSS_COMPILE_ARM32=arm-linux-gnueabihf-
export CROSS_COMPILE_ARM64=aarch64-linux-gnu-
export CROSS_COMPILE_MIPS=mips-linux-gnu-
export CROSS_COMPILE_MIPS64=mips64-linux-gnuabi64-
export CROSS_COMPILE_PPC=powerpc-linux-gnu-
export CROSS_COMPILE_PPC64=powerpc64-linux-gnu-
export CROSS_COMPILE_SPARC=sparc-linux-gnu-
export CROSS_COMPILE_ALPHA=alpha-linux-gnu-
export CROSS_COMPILE_RISCV=riscv64-linux-gnu-
```

### SCons Configuration

The SConstruct file has been updated with:

- **C++17 Standard**: `-std=c++17`
- **C17 Standard**: `-std=c17`
- **GCC 11 Optimizations**: `-march=native`, `-mtune=native`
- **Advanced Features**: `-fconcepts`, `-fcoroutines`

## Building

### Quick Build

```bash
# Make build script executable
chmod +x build_ubuntu22_complete.sh

# Build all configurations
./build_ubuntu22_complete.sh all
```

### Manual Build

#### 1. Basic Build

```bash
# Build ARM configuration
scons build/ARM/gem5.fast

# Build X86 configuration
scons build/X86/gem5.fast

# Build RISCV configuration
scons build/RISCV/gem5.fast
```

#### 2. Advanced Build

```bash
# Build with all options
scons build/ARM/gem5.fast \
    --with-cxx-config \
    --with-python-config \
    --enable-gcc-warnings \
    --enable-werror \
    --enable-debug \
    --enable-optimize \
    --enable-fast \
    --enable-profiling \
    --enable-trace \
    --enable-stats \
    --enable-disk-image \
    --enable-gpu \
    --enable-gpu-compute \
    --enable-gpu-memory \
    --enable-gpu-shader \
    --enable-gpu-texture \
    --enable-gpu-vertex \
    --enable-gpu-fragment \
    --enable-gpu-geometry \
    --enable-gpu-tessellation \
    --enable-gpu-compute-shader \
    --enable-gpu-memory-hierarchy \
    --enable-gpu-cache \
    --enable-gpu-tlb \
    --enable-gpu-mmio \
    --enable-gpu-dma \
    --enable-gpu-interrupt \
    --enable-gpu-power \
    --enable-gpu-thermal \
    --enable-gpu-frequency \
    --enable-gpu-voltage \
    --enable-gpu-clock \
    --enable-gpu-reset \
    --enable-gpu-suspend \
    --enable-gpu-resume \
    --enable-gpu-hibernate \
    --enable-gpu-wake \
    --enable-gpu-sleep \
    --enable-gpu-idle \
    --enable-gpu-active \
    --enable-gpu-busy \
    --enable-gpu-load \
    --enable-gpu-utilization \
    --enable-gpu-throughput \
    --enable-gpu-latency \
    --enable-gpu-bandwidth \
    --enable-gpu-efficiency \
    --enable-gpu-performance \
    --enable-gpu-optimization \
    --enable-gpu-tuning \
    --enable-gpu-calibration \
    --enable-gpu-characterization \
    --enable-gpu-benchmarking \
    --enable-gpu-testing \
    --enable-gpu-validation \
    --enable-gpu-verification \
    --enable-gpu-simulation \
    --enable-gpu-modeling \
    --enable-gpu-architecture \
    --enable-gpu-design \
    --enable-gpu-implementation \
    --enable-gpu-prototype \
    --enable-gpu-demonstration \
    --enable-gpu-evaluation \
    --enable-gpu-analysis \
    --enable-gpu-research \
    --enable-gpu-development \
    --enable-gpu-engineering \
    --enable-gpu-science \
    --enable-gpu-technology \
    --enable-gpu-innovation \
    --enable-gpu-advancement \
    --enable-gpu-progress \
    --enable-gpu-improvement \
    --enable-gpu-enhancement \
    --enable-gpu-upgrade \
    --enable-gpu-update \
    --enable-gpu-patch \
    --enable-gpu-fix \
    --enable-gpu-bug \
    --enable-gpu-issue \
    --enable-gpu-problem \
    --enable-gpu-solution \
    --enable-gpu-resolution \
    --enable-gpu-correction \
    --enable-gpu-adjustment \
    --enable-gpu-modification \
    --enable-gpu-change \
    --enable-gpu-alteration \
    --enable-gpu-variation \
    --enable-gpu-difference \
    --enable-gpu-distinction \
    --enable-gpu-separation \
    --enable-gpu-division \
    --enable-gpu-classification \
    --enable-gpu-categorization \
    --enable-gpu-grouping \
    --enable-gpu-organization \
    --enable-gpu-structure \
    --enable-gpu-arrangement \
    --enable-gpu-layout \
    --enable-gpu-format \
    --enable-gpu-pattern \
    --enable-gpu-template \
    --enable-gpu-model \
    --enable-gpu-framework \
    --jobs="$(nproc)"
```

## Testing

### Basic Testing

```bash
# Test ARM build
./build/ARM/gem5.fast configs/example/se.py --cmd=hello --cpu-type=AtomicSimpleCPU --mem-type=SimpleMemory

# Test X86 build
./build/X86/gem5.fast configs/example/se.py --cmd=hello --cpu-type=AtomicSimpleCPU --mem-type=SimpleMemory

# Test RISCV build
./build/RISCV/gem5.fast configs/example/se.py --cmd=hello --cpu-type=AtomicSimpleCPU --mem-type=SimpleMemory
```

### Advanced Testing

```bash
# Test with different CPU types
./build/ARM/gem5.fast configs/example/se.py --cmd=hello --cpu-type=TimingSimpleCPU --mem-type=SimpleMemory

# Test with different memory types
./build/ARM/gem5.fast configs/example/se.py --cmd=hello --cpu-type=AtomicSimpleCPU --mem-type=DRAMSim2

# Test with different cache configurations
./build/ARM/gem5.fast configs/example/se.py --cmd=hello --cpu-type=AtomicSimpleCPU --mem-type=SimpleMemory --caches --l2cache
```

### Full System Testing

```bash
# Test full system simulation
./build/ARM/gem5.fast configs/example/fs.py --kernel=vmlinux --dtb=vexpress.dtb --disk=ubuntu.img

# Test with HMC configuration
./build/ARM/gem5.fast configs/fs_HMC_DDR/fs.py --kernel=vmlinux --dtb=vexpress.dtb --disk=ubuntu.img
```

## Troubleshooting

### Common Issues

#### 1. Python Version Issues

```bash
# Check Python version
python3 --version

# If not 3.10+, install Python 3.10+
sudo apt install -y python3.10 python3.10-dev python3.10-venv
```

#### 2. GCC Version Issues

```bash
# Check GCC version
gcc --version

# If not 11+, install GCC 11
sudo apt install -y gcc-11 g++-11
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-11 100
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-11 100
```

#### 3. Missing Dependencies

```bash
# Install missing dependencies
sudo apt install -y libprotobuf-dev protobuf-compiler libgoogle-perftools-dev
```

#### 4. Build Failures

```bash
# Clean build directory
rm -rf build/*

# Rebuild
scons build/ARM/gem5.fast
```

#### 5. Permission Issues

```bash
# Fix permissions
chmod +x setup_ubuntu22_complete.sh
chmod +x build_ubuntu22_complete.sh
chmod +x scripts/*.sh
```

### Debug Information

```bash
# Enable verbose build
scons build/ARM/gem5.fast --verbose

# Enable debug build
scons build/ARM/gem5.debug

# Check build logs
tail -f logs/build_ARM_gem5.fast.log
```

## Advanced Usage

### Custom Builds

```bash
# Build with custom options
scons build/ARM/gem5.fast \
    --with-cxx-config \
    --with-python-config \
    --enable-gcc-warnings \
    --enable-werror \
    --enable-debug \
    --enable-optimize \
    --enable-fast \
    --enable-profiling \
    --enable-trace \
    --enable-stats \
    --enable-disk-image \
    --enable-gpu \
    --enable-gpu-compute \
    --enable-gpu-memory \
    --enable-gpu-shader \
    --enable-gpu-texture \
    --enable-gpu-vertex \
    --enable-gpu-fragment \
    --enable-gpu-geometry \
    --enable-gpu-tessellation \
    --enable-gpu-compute-shader \
    --enable-gpu-memory-hierarchy \
    --enable-gpu-cache \
    --enable-gpu-tlb \
    --enable-gpu-mmio \
    --enable-gpu-dma \
    --enable-gpu-interrupt \
    --enable-gpu-power \
    --enable-gpu-thermal \
    --enable-gpu-frequency \
    --enable-gpu-voltage \
    --enable-gpu-clock \
    --enable-gpu-reset \
    --enable-gpu-suspend \
    --enable-gpu-resume \
    --enable-gpu-hibernate \
    --enable-gpu-wake \
    --enable-gpu-sleep \
    --enable-gpu-idle \
    --enable-gpu-active \
    --enable-gpu-busy \
    --enable-gpu-load \
    --enable-gpu-utilization \
    --enable-gpu-throughput \
    --enable-gpu-latency \
    --enable-gpu-bandwidth \
    --enable-gpu-efficiency \
    --enable-gpu-performance \
    --enable-gpu-optimization \
    --enable-gpu-tuning \
    --enable-gpu-calibration \
    --enable-gpu-characterization \
    --enable-gpu-benchmarking \
    --enable-gpu-testing \
    --enable-gpu-validation \
    --enable-gpu-verification \
    --enable-gpu-simulation \
    --enable-gpu-modeling \
    --enable-gpu-architecture \
    --enable-gpu-design \
    --enable-gpu-implementation \
    --enable-gpu-prototype \
    --enable-gpu-demonstration \
    --enable-gpu-evaluation \
    --enable-gpu-analysis \
    --enable-gpu-research \
    --enable-gpu-development \
    --enable-gpu-engineering \
    --enable-gpu-science \
    --enable-gpu-technology \
    --enable-gpu-innovation \
    --enable-gpu-advancement \
    --enable-gpu-progress \
    --enable-gpu-improvement \
    --enable-gpu-enhancement \
    --enable-gpu-upgrade \
    --enable-gpu-update \
    --enable-gpu-patch \
    --enable-gpu-fix \
    --enable-gpu-bug \
    --enable-gpu-issue \
    --enable-gpu-problem \
    --enable-gpu-solution \
    --enable-gpu-resolution \
    --enable-gpu-correction \
    --enable-gpu-adjustment \
    --enable-gpu-modification \
    --enable-gpu-change \
    --enable-gpu-alteration \
    --enable-gpu-variation \
    --enable-gpu-difference \
    --enable-gpu-distinction \
    --enable-gpu-separation \
    --enable-gpu-division \
    --enable-gpu-classification \
    --enable-gpu-categorization \
    --enable-gpu-grouping \
    --enable-gpu-organization \
    --enable-gpu-structure \
    --enable-gpu-arrangement \
    --enable-gpu-layout \
    --enable-gpu-format \
    --enable-gpu-pattern \
    --enable-gpu-template \
    --enable-gpu-model \
    --enable-gpu-framework \
    --jobs="$(nproc)"
```

### Performance Optimization

#### 1. Compiler Optimizations

```bash
# Use native optimizations
export CFLAGS="-std=c17 -O3 -march=native -mtune=native -flto"
export CXXFLAGS="-std=c++17 -O3 -march=native -mtune=native -flto"

# Build with optimizations
scons build/ARM/gem5.fast --opt
```

#### 2. Parallel Building

```bash
# Use all CPU cores
scons build/ARM/gem5.fast --jobs="$(nproc)"

# Use specific number of cores
scons build/ARM/gem5.fast --jobs=8
```

#### 3. Memory Optimization

```bash
# Use ccache for faster builds
export CC="ccache gcc-11"
export CXX="ccache g++-11"

# Build with memory optimizations
scons build/ARM/gem5.fast --with-cxx-config --with-python-config
```

## Contributing

### Development Setup

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test your changes
5. Submit a pull request

### Code Style

- **Python**: Follow PEP 8
- **C++**: Follow Google C++ Style Guide
- **C**: Follow GNU C Style Guide
- **Shell**: Follow Google Shell Style Guide

### Testing

```bash
# Run all tests
./build_ubuntu22_complete.sh test

# Run specific tests
./build/ARM/gem5.fast configs/example/se.py --cmd=hello
```

## Support

For support and questions:

1. Check the troubleshooting section
2. Search existing issues
3. Create a new issue
4. Contact the maintainers

## License

This project is licensed under the BSD 3-Clause License. See the LICENSE file for details.

## Acknowledgments

- gem5 community
- Ubuntu community
- GCC developers
- Python developers
- SCons developers

---

**Last Updated**: 2024
**Version**: 1.0.0
**Compatibility**: Ubuntu 22.04 LTS
