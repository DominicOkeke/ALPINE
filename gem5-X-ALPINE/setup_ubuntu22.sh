#!/bin/bash
# ALPINE gem5-X-ALPINE Ubuntu 22.04 Setup Script
# This script sets up the development environment for gem5-X-ALPINE on Ubuntu 22.04

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
    if [[ ! -f /etc/os-release ]]; then
        log_error "Cannot determine OS version. This script is designed for Ubuntu 22.04."
        exit 1
    fi
    
    source /etc/os-release
    if [[ "$ID" != "ubuntu" ]] || [[ "$VERSION_ID" != "22.04" ]]; then
        log_warning "This script is designed for Ubuntu 22.04. Current OS: $PRETTY_NAME"
        read -p "Continue anyway? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    else
        log_success "Detected Ubuntu 22.04"
    fi
}

# Update system packages
update_system() {
    log_info "Updating system packages..."
    sudo apt update
    sudo apt upgrade -y
    log_success "System packages updated"
}

# Install essential build tools
install_build_tools() {
    log_info "Installing essential build tools..."
    
    # Essential packages for gem5 development
    local packages=(
        "build-essential"
        "gcc-11"
        "g++-11"
        "gcc-11-multilib"
        "g++-11-multilib"
        "python3"
        "python3-dev"
        "python3-pip"
        "python3-venv"
        "scons"
        "swig"
        "zlib1g-dev"
        "m4"
        "libprotobuf-dev"
        "protobuf-compiler"
        "libgoogle-perftools-dev"
        "libhdf5-dev"
        "libboost-all-dev"
        "libtcmalloc-minimal4"
        "libgoogle-perftools4"
        "libunwind-dev"
        "libelf-dev"
        "libdwarf-dev"
        "libbz2-dev"
        "liblzma-dev"
        "libzstd-dev"
        "libssl-dev"
        "libffi-dev"
        "libsqlite3-dev"
        "libreadline-dev"
        "libncurses5-dev"
        "libncursesw5-dev"
        "libgdbm-dev"
        "libnss3-dev"
        "libxss1"
        "libasound2-dev"
        "libxtst6"
        "libxrandr2"
        "libasound2"
        "libpangocairo-1.0-0"
        "libatk1.0-0"
        "libcairo-gobject2"
        "libgtk-3-0"
        "libgdk-pixbuf2.0-0"
        "git"
        "wget"
        "curl"
        "vim"
        "nano"
        "htop"
        "tree"
        "jq"
        "unzip"
        "pkg-config"
        "cmake"
        "ninja-build"
        "valgrind"
        "gdb"
        "strace"
        "ltrace"
    )
    
    sudo apt install -y "${packages[@]}"
    log_success "Build tools installed"
}

# Set up Python 3 environment
setup_python() {
    log_info "Setting up Python 3 environment..."
    
    # Check Python version
    local python_version=$(python3 --version | cut -d' ' -f2 | cut -d'.' -f1,2)
    log_info "Python version: $python_version"
    
    # Install Python packages
    pip3 install --user --upgrade pip
    pip3 install --user \
        scons \
        protobuf \
        pyyaml \
        matplotlib \
        numpy \
        scipy \
        pandas \
        jupyter \
        ipython \
        pytest \
        black \
        flake8 \
        mypy \
        pylint
    
    log_success "Python environment set up"
}

# Configure GCC 11 as default
configure_gcc() {
    log_info "Configuring GCC 11 as default compiler..."
    
    # Set up alternatives for GCC 11
    sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-11 100
    sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-11 100
    
    # Verify versions
    log_info "GCC version: $(gcc --version | head -n1)"
    log_info "G++ version: $(g++ --version | head -n1)"
    
    log_success "GCC 11 configured as default"
}

# Set up environment variables
setup_environment() {
    log_info "Setting up environment variables..."
    
    local gem5_root="$(dirname "$(realpath "$0")")"
    local env_file="$HOME/.gem5_env"
    
    cat > "$env_file" << EOF
# ALPINE gem5-X-ALPINE Environment Variables for Ubuntu 22.04
export M5_PATH="\$HOME/gem5"
export GEM5_ROOT="$gem5_root"
export PYTHONPATH="\$GEM5_ROOT/src/python:\$PYTHONPATH"
export PATH="\$GEM5_ROOT/util:\$PATH"

# C++17 and GCC 11 settings
export CC=gcc-11
export CXX=g++-11
export CXXFLAGS="-std=c++17 -Wall -Wextra -O3 -march=native -mtune=native"
export CFLAGS="-Wall -Wextra -O3 -march=native -mtune=native"

# Python settings
export PYTHON3=python3
export PYTHON=python3

# Build settings
export SCONSFLAGS="-j\$(nproc)"
EOF
    
    # Add to shell profile
    if [[ -f "$HOME/.bashrc" ]]; then
        if ! grep -q "gem5_env" "$HOME/.bashrc"; then
            echo "source $env_file" >> "$HOME/.bashrc"
        fi
    fi
    
    if [[ -f "$HOME/.zshrc" ]]; then
        if ! grep -q "gem5_env" "$HOME/.zshrc"; then
            echo "source $env_file" >> "$HOME/.zshrc"
        fi
    fi
    
    log_success "Environment variables set up"
    log_info "To activate the environment, run: source $env_file"
}

# Create build directories
create_build_dirs() {
    log_info "Creating build directories..."
    
    local gem5_root="$(dirname "$(realpath "$0")")"
    mkdir -p "$gem5_root/build"
    mkdir -p "$HOME/gem5"
    
    log_success "Build directories created"
}

# Test the setup
test_setup() {
    log_info "Testing the setup..."
    
    # Test GCC
    if gcc --version | grep -q "gcc-11"; then
        log_success "GCC 11 is working"
    else
        log_error "GCC 11 test failed"
        return 1
    fi
    
    # Test Python
    if python3 --version | grep -q "Python 3"; then
        log_success "Python 3 is working"
    else
        log_error "Python 3 test failed"
        return 1
    fi
    
    # Test SCons
    if scons --version > /dev/null 2>&1; then
        log_success "SCons is working"
    else
        log_error "SCons test failed"
        return 1
    fi
    
    log_success "Setup test completed successfully"
}

# Main installation function
main() {
    echo "ALPINE gem5-X-ALPINE Ubuntu 22.04 Setup"
    echo "======================================="
    echo
    
    check_ubuntu_version
    update_system
    install_build_tools
    setup_python
    configure_gcc
    setup_environment
    create_build_dirs
    test_setup
    
    echo
    log_success "Setup completed successfully!"
    echo
    echo "Next steps:"
    echo "1. Source the environment: source ~/.gem5_env"
    echo "2. Build gem5: cd $GEM5_ROOT && scons build/ARM/gem5.fast"
    echo "3. Run simulations using the provided scripts"
    echo
    echo "For more information, see the README files in the project directory."
}

# Run main function
main "$@"
