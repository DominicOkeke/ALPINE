#!/bin/bash
# ALPINE gem5-X-ALPINE Build Script for Ubuntu 22.04
# This script builds gem5 with C++17 and GCC 11 optimizations

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

# Configuration
readonly GEM5_ROOT="$(dirname "$(realpath "$0")")"
readonly BUILD_DIR="${GEM5_ROOT}/build"
readonly JOBS="${JOBS:-$(nproc)}"

# Default build options
BUILD_TYPE="fast"
ARCH="ARM"
CLEAN=false
VERBOSE=false
DEBUG=false

# Parse command line arguments
parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -a|--arch)
                ARCH="$2"
                shift 2
                ;;
            -t|--type)
                BUILD_TYPE="$2"
                shift 2
                ;;
            -c|--clean)
                CLEAN=true
                shift
                ;;
            -v|--verbose)
                VERBOSE=true
                shift
                ;;
            -d|--debug)
                DEBUG=true
                shift
                ;;
            -j|--jobs)
                JOBS="$2"
                shift 2
                ;;
            -h|--help)
                show_help
                exit 0
                ;;
            *)
                log_error "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done
}

# Show help message
show_help() {
    cat << EOF
ALPINE gem5-X-ALPINE Build Script for Ubuntu 22.04

Usage: $0 [OPTIONS]

Options:
    -a, --arch ARCH      Target architecture (ARM, X86, RISCV, etc.) [default: ARM]
    -t, --type TYPE      Build type (fast, debug, opt) [default: fast]
    -c, --clean          Clean build directory before building
    -v, --verbose        Verbose output
    -d, --debug          Enable debug symbols
    -j, --jobs JOBS      Number of parallel jobs [default: \$(nproc)]
    -h, --help           Show this help message

Examples:
    $0                           # Build ARM fast version
    $0 -a X86 -t opt             # Build X86 optimized version
    $0 -c -v -j 8                # Clean build with verbose output and 8 jobs
    $0 -d -t debug               # Build debug version with debug symbols

EOF
}

# Check system requirements
check_requirements() {
    log_info "Checking system requirements..."
    
    # Check if we're in the right directory
    if [[ ! -f "${GEM5_ROOT}/SConstruct" ]]; then
        log_error "SConstruct not found. Please run this script from the gem5 root directory."
        exit 1
    fi
    
    # Check GCC version
    if ! command -v gcc &> /dev/null; then
        log_error "GCC not found. Please install GCC 11+."
        exit 1
    fi
    
    local gcc_version=$(gcc -dumpversion | cut -d. -f1)
    if [[ $gcc_version -lt 11 ]]; then
        log_warning "GCC version $gcc_version detected. GCC 11+ recommended for C++17 features."
    else
        log_success "GCC version $gcc_version detected"
    fi
    
    # Check Python version
    if ! command -v python3 &> /dev/null; then
        log_error "Python 3 not found. Please install Python 3.10+."
        exit 1
    fi
    
    local python_version=$(python3 --version | cut -d' ' -f2 | cut -d'.' -f1,2)
    log_success "Python version: $python_version"
    
    # Check SCons
    if ! command -v scons &> /dev/null; then
        log_error "SCons not found. Please install SCons."
        exit 1
    fi
    
    log_success "System requirements check passed"
}

# Set up environment
setup_environment() {
    log_info "Setting up build environment..."
    
    # Set environment variables
    export M5_PATH="${M5_PATH:-$HOME/gem5}"
    export GEM5_ROOT="$GEM5_ROOT"
    export PYTHONPATH="$GEM5_ROOT/src/python:$PYTHONPATH"
    export PATH="$GEM5_ROOT/util:$PATH"
    
    # Set compiler
    export CC="${CC:-gcc-11}"
    export CXX="${CXX:-g++-11}"
    
    # Set C++17 flags
    export CXXFLAGS="-std=c++17 -Wall -Wextra -Wpedantic"
    
    # Add optimization flags
    if [[ "$BUILD_TYPE" == "opt" ]]; then
        export CXXFLAGS="$CXXFLAGS -O3 -march=native -mtune=native"
    elif [[ "$BUILD_TYPE" == "fast" ]]; then
        export CXXFLAGS="$CXXFLAGS -O2 -march=native"
    elif [[ "$BUILD_TYPE" == "debug" ]]; then
        export CXXFLAGS="$CXXFLAGS -O0 -g"
    fi
    
    # Add debug symbols if requested
    if [[ "$DEBUG" == true ]]; then
        export CXXFLAGS="$CXXFLAGS -g -DDEBUG"
    fi
    
    # Set SCons flags
    export SCONSFLAGS="-j$JOBS"
    if [[ "$VERBOSE" == true ]]; then
        export SCONSFLAGS="$SCONSFLAGS --verbose"
    fi
    
    log_success "Environment set up"
    log_info "CC: $CC"
    log_info "CXX: $CXX"
    log_info "CXXFLAGS: $CXXFLAGS"
    log_info "SCONSFLAGS: $SCONSFLAGS"
}

# Clean build directory
clean_build() {
    if [[ "$CLEAN" == true ]]; then
        log_info "Cleaning build directory..."
        cd "$GEM5_ROOT"
        scons -c
        log_success "Build directory cleaned"
    fi
}

# Build gem5
build_gem5() {
    log_info "Building gem5 for $ARCH architecture ($BUILD_TYPE)..."
    
    cd "$GEM5_ROOT"
    
    local target="build/$ARCH/gem5.$BUILD_TYPE"
    log_info "Target: $target"
    
    # Build with SCons
    if scons $SCONSFLAGS "$target"; then
        log_success "Build completed successfully"
        
        # Check if binary exists
        if [[ -f "$target" ]]; then
            local size=$(du -h "$target" | cut -f1)
            log_success "Binary created: $target (Size: $size)"
        else
            log_error "Binary not found: $target"
            exit 1
        fi
    else
        log_error "Build failed"
        exit 1
    fi
}

# Run tests (optional)
run_tests() {
    if [[ "$BUILD_TYPE" == "fast" ]] || [[ "$BUILD_TYPE" == "opt" ]]; then
        log_info "Running basic tests..."
        
        # Test if binary runs
        if "$BUILD_DIR/$ARCH/gem5.$BUILD_TYPE" --help > /dev/null 2>&1; then
            log_success "Basic test passed"
        else
            log_warning "Basic test failed"
        fi
    fi
}

# Show build summary
show_summary() {
    echo
    log_success "Build Summary"
    echo "=============="
    echo "Architecture: $ARCH"
    echo "Build Type: $BUILD_TYPE"
    echo "Jobs: $JOBS"
    echo "Binary: $BUILD_DIR/$ARCH/gem5.$BUILD_TYPE"
    echo
    echo "Next steps:"
    echo "1. Run simulation: ./scripts/fs_HMC.sh"
    echo "2. Check configuration: $GEM5_ROOT/configs/"
    echo "3. View documentation: $GEM5_ROOT/README_UBUNTU22.md"
    echo
}

# Main function
main() {
    echo "ALPINE gem5-X-ALPINE Build Script for Ubuntu 22.04"
    echo "=================================================="
    echo
    
    parse_args "$@"
    check_requirements
    setup_environment
    clean_build
    build_gem5
    run_tests
    show_summary
}

# Run main function
main "$@"
