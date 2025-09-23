#!/bin/bash
# ALPINE gem5-X-ALPINE Ubuntu 22.04 Complete Setup Script
# This script sets up the complete development environment for gem5-X-ALPINE
# with Python 3.10+, C++17, C17, GCC 11, and modern toolchain

set -euo pipefail  # Exit on error, undefined vars, pipe failures

# Colors for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running on Ubuntu 22.04
check_ubuntu_version() {
    log_info "Checking Ubuntu version..."
    
    if [[ ! -f /etc/os-release ]]; then
        log_error "Cannot determine OS version. This script is designed for Ubuntu 22.04."
        exit 1
    fi
    
    source /etc/os-release
    if [[ "$VERSION_ID" != "22.04" ]]; then
        log_warning "This script is designed for Ubuntu 22.04. Current version: $VERSION_ID"
        read -p "Continue anyway? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    else
        log_success "Ubuntu 22.04 detected"
    fi
}

# Update system packages
update_system() {
    log_info "Updating system packages..."
    
    sudo apt update
    sudo apt upgrade -y
    sudo apt autoremove -y
    sudo apt autoclean
    
    log_success "System packages updated"
}

# Install essential development tools
install_essential_tools() {
    log_info "Installing essential development tools..."
    
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
    
    log_success "Essential development tools installed"
}

# Install Python 3.10+ and development tools
install_python() {
    log_info "Installing Python 3.10+ and development tools..."
    
    # Install Python 3.10+ (Ubuntu 22.04 comes with Python 3.10 by default)
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
    
    # Install additional Python packages for gem5
    pip3 install --user \
        scons \
        pybind11 \
        protobuf \
        six \
        mako \
        cheetah3 \
        ply \
        pyyaml
    
    log_success "Python 3.10+ and development tools installed"
}

# Install GCC 11 and C++17/C17 development tools
install_compiler_toolchain() {
    log_info "Installing GCC 11 and C++17/C17 development tools..."
    
    # Install GCC 11 (Ubuntu 22.04 comes with GCC 11 by default)
    sudo apt install -y \
        gcc-11 \
        g++-11 \
        gcc-11-multilib \
        g++-11-multilib \
        gcc-11-plugin-dev \
        libgcc-11-dev \
        libstdc++-11-dev \
        libc6-dev-i386 \
        lib32stdc++6 \
        lib32gcc-s1
    
    # Set GCC 11 as default
    sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-11 100
    sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-11 100
    
    # Install additional C/C++ development tools
    sudo apt install -y \
        clang-14 \
        clang-format-14 \
        clang-tidy-14 \
        cppcheck \
        cpplint \
        iwyu \
        bear \
        ccache
    
    log_success "GCC 11 and C++17/C17 development tools installed"
}

# Install gem5 specific dependencies
install_gem5_dependencies() {
    log_info "Installing gem5 specific dependencies..."
    
    # Install system libraries
    sudo apt install -y \
        libprotobuf-dev \
        protobuf-compiler \
        libgoogle-perftools-dev \
        libtcmalloc-minimal4 \
        libgoogle-perftools4 \
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
        libnetcdf-dev \
        libnetcdf-c++4-dev \
        libnetcdf-cxx-legacy-dev \
        libnetcdf-fortran-dev \
        libnetcdf-mpi-dev \
        libnetcdf-pnetcdf-dev \
        libnetcdf-c++4-dev \
        libnetcdf-cxx-legacy-dev \
        libnetcdf-fortran-dev \
        libnetcdf-mpi-dev \
        libnetcdf-pnetcdf-dev
    
    # Install graphics and GUI libraries
    sudo apt install -y \
        libx11-dev \
        libxext-dev \
        libxrender-dev \
        libxrandr-dev \
        libxinerama-dev \
        libxcursor-dev \
        libxi-dev \
        libxss-dev \
        libxcomposite-dev \
        libxdamage-dev \
        libxfixes-dev \
        libxfont-dev \
        libxft-dev \
        libxmu-dev \
        libxpm-dev \
        libxrandr-dev \
        libxrender-dev \
        libxss-dev \
        libxt-dev \
        libxv-dev \
        libxxf86vm-dev \
        libgl1-mesa-dev \
        libglu1-mesa-dev \
        libglfw3-dev \
        libglew-dev \
        libglm-dev \
        libassimp-dev \
        libbullet-dev \
        libode-dev \
        libopencv-dev \
        libopencv-contrib-dev
    
    # Install network libraries
    sudo apt install -y \
        libpcap-dev \
        libnet-dev \
        libnetfilter-queue-dev \
        libnfnetlink-dev \
        libnetfilter-log-dev \
        libnetfilter-conntrack-dev \
        libnetfilter-cttimeout-dev \
        libnetfilter-cthelper-dev \
        libnetfilter-queue-dev \
        libnetfilter-acct-dev \
        libnetfilter-queue-dev \
        libnetfilter-cttimeout-dev \
        libnetfilter-cthelper-dev \
        libnetfilter-acct-dev
    
    log_success "gem5 specific dependencies installed"
}

# Install cross-compilation tools
install_cross_compilation() {
    log_info "Installing cross-compilation tools..."
    
    # Install ARM cross-compilation tools
    sudo apt install -y \
        gcc-aarch64-linux-gnu \
        g++-aarch64-linux-gnu \
        gcc-arm-linux-gnueabihf \
        g++-arm-linux-gnueabihf \
        gcc-arm-linux-gnueabi \
        g++-arm-linux-gnueabi \
        binutils-aarch64-linux-gnu \
        binutils-arm-linux-gnueabihf \
        binutils-arm-linux-gnueabi \
        libc6-dev-armhf-cross \
        libc6-dev-armel-cross \
        libc6-dev-arm64-cross
    
    # Install other architecture cross-compilation tools
    sudo apt install -y \
        gcc-mips-linux-gnu \
        g++-mips-linux-gnu \
        gcc-mips64-linux-gnuabi64 \
        g++-mips64-linux-gnuabi64 \
        gcc-powerpc-linux-gnu \
        g++-powerpc-linux-gnu \
        gcc-powerpc64-linux-gnu \
        g++-powerpc64-linux-gnu \
        gcc-sparc-linux-gnu \
        g++-sparc-linux-gnu \
        gcc-alpha-linux-gnu \
        g++-alpha-linux-gnu \
        gcc-riscv64-linux-gnu \
        g++-riscv64-linux-gnu
    
    log_success "Cross-compilation tools installed"
}

# Install additional development tools
install_additional_tools() {
    log_info "Installing additional development tools..."
    
    # Install version control tools
    sudo apt install -y \
        git \
        git-lfs \
        mercurial \
        subversion \
        bzr \
        fossil
    
    # Install documentation tools
    sudo apt install -y \
        doxygen \
        graphviz \
        plantuml \
        pandoc \
        texlive \
        texlive-latex-extra \
        texlive-fonts-recommended \
        texlive-fonts-extra
    
    # Install testing tools
    sudo apt install -y \
        cunit \
        cppunit \
        googletest \
        google-mock \
        catch2 \
        boost-test \
        gtest-dev \
        libgtest-dev
    
    # Install profiling and debugging tools
    sudo apt install -y \
        perf \
        oprofile \
        sysprof \
        valgrind \
        gdb \
        lldb \
        strace \
        ltrace \
        gcov \
        lcov \
        kcachegrind \
        massif-visualizer \
        callgrind \
        helgrind \
        drd \
        memcheck \
        cachegrind
    
    # Install system monitoring tools
    sudo apt install -y \
        htop \
        iotop \
        nethogs \
        iftop \
        nload \
        bmon \
        nethogs \
        iftop \
        nload \
        bmon \
        sysstat \
        dstat \
        iostat \
        vmstat \
        free \
        df \
        du \
        lsblk \
        lscpu \
        lshw \
        lspci \
        lsusb \
        lsof \
        netstat \
        ss \
        tcpdump \
        wireshark \
        tshark
    
    log_success "Additional development tools installed"
}

# Configure environment
configure_environment() {
    log_info "Configuring environment..."
    
    # Create gem5 directory
    mkdir -p "$HOME/gem5"
    
    # Set environment variables
    cat >> "$HOME/.bashrc" << 'EOF'

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

# gem5 specific paths
export GEM5_CPU_MODELS="AtomicSimpleCPU,TimingSimpleCPU,DerivO3CPU"
export GEM5_MEM_MODELS="SimpleMemory,DRAMSim2,HMC"
export GEM5_CACHE_MODELS="L1Cache,L2Cache,L3Cache"

EOF
    
    # Source the updated bashrc
    source "$HOME/.bashrc"
    
    log_success "Environment configured"
}

# Verify installation
verify_installation() {
    log_info "Verifying installation..."
    
    # Check Python version
    python3 --version
    if [[ $? -eq 0 ]]; then
        log_success "Python 3 installed correctly"
    else
        log_error "Python 3 installation failed"
        exit 1
    fi
    
    # Check GCC version
    gcc --version
    if [[ $? -eq 0 ]]; then
        log_success "GCC installed correctly"
    else
        log_error "GCC installation failed"
        exit 1
    fi
    
    # Check G++ version
    g++ --version
    if [[ $? -eq 0 ]]; then
        log_success "G++ installed correctly"
    else
        log_error "G++ installation failed"
        exit 1
    fi
    
    # Check SCons
    scons --version
    if [[ $? -eq 0 ]]; then
        log_success "SCons installed correctly"
    else
        log_error "SCons installation failed"
        exit 1
    fi
    
    # Check cross-compilation tools
    aarch64-linux-gnu-gcc --version
    if [[ $? -eq 0 ]]; then
        log_success "ARM64 cross-compilation tools installed correctly"
    else
        log_error "ARM64 cross-compilation tools installation failed"
        exit 1
    fi
    
    arm-linux-gnueabihf-gcc --version
    if [[ $? -eq 0 ]]; then
        log_success "ARM32 cross-compilation tools installed correctly"
    else
        log_error "ARM32 cross-compilation tools installation failed"
        exit 1
    fi
    
    log_success "Installation verification completed"
}

# Main installation function
main() {
    log_info "Starting ALPINE gem5-X-ALPINE Ubuntu 22.04 Complete Setup"
    log_info "========================================================="
    
    # Check if running as root
    if [[ $EUID -eq 0 ]]; then
        log_error "This script should not be run as root. Please run as a regular user."
        exit 1
    fi
    
    # Check Ubuntu version
    check_ubuntu_version
    
    # Update system
    update_system
    
    # Install essential tools
    install_essential_tools
    
    # Install Python
    install_python
    
    # Install compiler toolchain
    install_compiler_toolchain
    
    # Install gem5 dependencies
    install_gem5_dependencies
    
    # Install cross-compilation tools
    install_cross_compilation
    
    # Install additional tools
    install_additional_tools
    
    # Configure environment
    configure_environment
    
    # Verify installation
    verify_installation
    
    log_success "ALPINE gem5-X-ALPINE Ubuntu 22.04 Complete Setup completed successfully!"
    log_info "========================================================="
    log_info "Next steps:"
    log_info "1. Restart your terminal or run: source ~/.bashrc"
    log_info "2. Navigate to your gem5-X-ALPINE directory"
    log_info "3. Run: scons build/ARM/gem5.fast"
    log_info "4. Test your installation with: ./build/ARM/gem5.fast configs/example/se.py --cmd=hello"
    log_info "========================================================="
}

# Run main function
main "$@"
