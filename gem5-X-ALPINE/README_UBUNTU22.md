# ALPINE gem5-X-ALPINE for Ubuntu 22.04

This document provides comprehensive instructions for setting up and using the ALPINE gem5-X-ALPINE simulator on Ubuntu 22.04 with modern toolchain support.

## 🚀 Quick Start

```bash
# 1. Clone and setup
git clone <repository-url>
cd gem5-X-ALPINE

# 2. Run automated setup
chmod +x setup_ubuntu22.sh
./setup_ubuntu22.sh

# 3. Build gem5
source ~/.gem5_env
scons build/ARM/gem5.fast

# 4. Run simulation
./scripts/fs_HMC.sh
```

## 📋 System Requirements

### Ubuntu 22.04 LTS
- **OS**: Ubuntu 22.04 LTS (Jammy Jellyfish)
- **Architecture**: x86_64 (AMD64)
- **RAM**: Minimum 8GB, Recommended 16GB+
- **Storage**: Minimum 20GB free space
- **CPU**: Multi-core processor recommended

### Software Dependencies
- **GCC**: 11.0+ (default in Ubuntu 22.04)
- **Python**: 3.10+ (default in Ubuntu 22.04)
- **SCons**: 4.0+
- **SWIG**: 4.0+
- **Protobuf**: 3.0+

## 🛠️ Manual Installation

### 1. Update System
```bash
sudo apt update && sudo apt upgrade -y
```

### 2. Install Essential Packages
```bash
# Core build tools
sudo apt install -y build-essential gcc-11 g++-11 gcc-11-multilib g++-11-multilib

# Python development
sudo apt install -y python3 python3-dev python3-pip python3-venv

# gem5 dependencies
sudo apt install -y scons swig zlib1g-dev m4 libprotobuf-dev protobuf-compiler
sudo apt install -y libgoogle-perftools-dev libhdf5-dev libboost-all-dev
sudo apt install -y libtcmalloc-minimal4 libgoogle-perftools4 libunwind-dev
sudo apt install -y libelf-dev libdwarf-dev libbz2-dev liblzma-dev libzstd-dev
sudo apt install -y libssl-dev libffi-dev libsqlite3-dev libreadline-dev
sudo apt install -y libncurses5-dev libncursesw5-dev libgdbm-dev libnss3-dev

# Additional tools
sudo apt install -y git wget curl vim nano htop tree jq unzip pkg-config
sudo apt install -y cmake ninja-build valgrind gdb strace ltrace
```

### 3. Configure GCC 11 as Default
```bash
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-11 100
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-11 100
```

### 4. Install Python Packages
```bash
pip3 install --user --upgrade pip
pip3 install --user scons protobuf pyyaml matplotlib numpy scipy pandas
pip3 install --user jupyter ipython pytest black flake8 mypy pylint
```

### 5. Set Up Environment
```bash
# Add to ~/.bashrc or ~/.zshrc
export M5_PATH="$HOME/gem5"
export GEM5_ROOT="$(pwd)"
export PYTHONPATH="$GEM5_ROOT/src/python:$PYTHONPATH"
export PATH="$GEM5_ROOT/util:$PATH"
export CC=gcc-11
export CXX=g++-11
export CXXFLAGS="-std=c++17 -Wall -Wextra -O3 -march=native -mtune=native"
export SCONSFLAGS="-j$(nproc)"
```

## 🔧 Build Configuration

### C++17 Features Used
- **Smart Pointers**: `std::unique_ptr`, `std::shared_ptr`
- **Auto Keyword**: Type deduction
- **Range-based Loops**: Modern iteration
- **Constexpr**: Compile-time evaluation
- **Lambda Expressions**: Functional programming
- **Move Semantics**: Performance optimization

### Compiler Optimizations
- **Architecture**: `-march=native -mtune=native`
- **Standards**: C++17 compliance
- **Warnings**: `-Wall -Wextra -Wpedantic`
- **Performance**: `-O3` optimization
- **Security**: `-fstack-protector-strong`

## 🏗️ Building gem5

### Basic Build
```bash
# ARM architecture (recommended for ALPINE)
scons build/ARM/gem5.fast

# X86 architecture
scons build/X86/gem5.fast

# Debug build
scons build/ARM/gem5.debug
```

### Advanced Build Options
```bash
# With specific CPU count
scons build/ARM/gem5.fast -j8

# With custom flags
CXXFLAGS="-std=c++17 -O3 -march=native" scons build/ARM/gem5.fast

# Clean build
scons -c
scons build/ARM/gem5.fast
```

## 🚀 Running Simulations

### HMC Simulation
```bash
# Basic HMC simulation
./scripts/fs_HMC.sh

# Kvazaar workload simulation
./scripts/fs_HMC_kvz.sh

# Custom simulation
build/ARM/gem5.fast configs/fs_HMC_DDR/fs.py \
    --machine-type=VExpress_GEM5_V1 \
    --kernel=vmlinux \
    --dtb=system/arm/dt/armv8_gem5_v1_4cpu.dtb \
    --main-num-cpus=4 \
    --caches \
    --cpu-type=AtomicSimpleCPU
```

### Configuration Files
- **fs_HMC_DDR/fs.py**: Main full-system configuration
- **fs_HMC_DDR/CacheConfig.py**: Cache hierarchy configuration
- **fs_HMC_DDR/MemConfig.py**: Memory system configuration

## 📊 Performance Tuning

### CPU Configuration
```python
# In config files
cpu_type = 'AtomicSimpleCPU'  # Fast simulation
# cpu_type = 'O3CPU'          # Detailed simulation
# cpu_type = 'MinorCPU'       # Balanced simulation
```

### Memory Configuration
```python
# DDR4 configuration
mem_type = 'DDR4_2400_4x16'
mem_ranks = 4
ddr_size = '4GB'
```

### Cache Configuration
```python
# L1 cache
l1i_size = '32kB'
l1d_size = '32kB'

# L2 cache
l2_size = '1MB'
l2_assoc = 2
```

## 🐛 Debugging

### Debug Build
```bash
scons build/ARM/gem5.debug
```

### GDB Debugging
```bash
gdb --args build/ARM/gem5.debug configs/fs_HMC_DDR/fs.py [options]
```

### Valgrind Memory Checking
```bash
valgrind --tool=memcheck --leak-check=full \
    build/ARM/gem5.debug configs/fs_HMC_DDR/fs.py [options]
```

### Profiling
```bash
# Using perf
perf record build/ARM/gem5.fast configs/fs_HMC_DDR/fs.py [options]
perf report

# Using gprof
CXXFLAGS="-pg" scons build/ARM/gem5.fast
./build/ARM/gem5.fast configs/fs_HMC_DDR/fs.py [options]
gprof build/ARM/gem5.fast gmon.out
```

## 📈 Monitoring and Analysis

### Statistics
```bash
# View simulation statistics
cat m5out/stats.txt

# Parse statistics
util/stats/stats.py m5out/stats.txt
```

### Visualization
```python
# Python analysis
import matplotlib.pyplot as plt
import pandas as pd

# Load statistics
stats = pd.read_csv('m5out/stats.txt', sep='\s+')
plt.plot(stats['sim_seconds'], stats['system.cpu.ipc'])
plt.show()
```

## 🔧 Troubleshooting

### Common Issues

#### 1. GCC Version Issues
```bash
# Check GCC version
gcc --version

# Set GCC 11 explicitly
export CC=gcc-11
export CXX=g++-11
```

#### 2. Python Import Errors
```bash
# Check Python path
echo $PYTHONPATH

# Add gem5 Python modules
export PYTHONPATH="$GEM5_ROOT/src/python:$PYTHONPATH"
```

#### 3. Build Failures
```bash
# Clean and rebuild
scons -c
scons build/ARM/gem5.fast

# Check dependencies
scons --tree=all build/ARM/gem5.fast
```

#### 4. Memory Issues
```bash
# Increase swap space
sudo fallocate -l 4G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
```

### Performance Issues

#### 1. Slow Compilation
```bash
# Use more CPU cores
export SCONSFLAGS="-j$(nproc)"

# Use ccache
sudo apt install ccache
export CC="ccache gcc-11"
export CXX="ccache g++-11"
```

#### 2. Slow Simulation
```bash
# Use faster CPU model
--cpu-type=AtomicSimpleCPU

# Reduce memory size
--ddr-size=1GB

# Disable detailed statistics
--stats-file=/dev/null
```

## 📚 Documentation

### Project Structure
```
gem5-X-ALPINE/
├── src/                    # Source code
│   ├── arch/              # Architecture-specific code
│   ├── cpu/               # CPU models
│   ├── mem/               # Memory system
│   └── python/            # Python bindings
├── configs/               # Configuration files
│   ├── fs_HMC_DDR/       # HMC DDR configurations
│   └── common/           # Common configurations
├── scripts/               # Shell scripts
├── util/                  # Utility programs
└── system/               # System software
```

### Key Files
- **SConstruct**: Main build configuration
- **setup_ubuntu22.sh**: Automated setup script
- **scripts/fs_HMC.sh**: HMC simulation script
- **configs/fs_HMC_DDR/**: HMC DDR configurations

## 🤝 Contributing

### Code Style
- **C++**: Follow C++17 best practices
- **Python**: Follow PEP 8 style guide
- **Shell**: Use modern bash features

### Testing
```bash
# Run tests
scons build/ARM/gem5.fast
./tests/run.py

# Style checking
util/style/style.py src/
```

## 📄 License

Copyright EPFL 2021 - MIT License

## 🆘 Support

For issues and questions:
1. Check this README
2. Search existing issues
3. Create a new issue with:
   - Ubuntu version
   - GCC version
   - Error messages
   - Steps to reproduce

## 🔄 Updates

### Version History
- **v2.0.0**: Ubuntu 22.04 support, C++17, GCC 11
- **v1.0.0**: Initial ALPINE release

### Future Plans
- Python 3.11+ support
- C++20 features
- Enhanced ARM support
- Improved performance monitoring
