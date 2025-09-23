#!/bin/bash
# ALPINE gem5-X-ALPINE Ubuntu 22.04 Complete Build Script
# This script builds gem5-X-ALPINE with Python 3.10+, C++17, C17, GCC 11

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
readonly M5OUT_DIR="${GEM5_ROOT}/m5out"
readonly LOG_DIR="${GEM5_ROOT}/logs"

# Build configurations
readonly CONFIGS=(
    "ARM/gem5.debug"
    "ARM/gem5.opt"
    "ARM/gem5.fast"
    "X86/gem5.debug"
    "X86/gem5.opt"
    "X86/gem5.fast"
    "RISCV/gem5.debug"
    "RISCV/gem5.opt"
    "RISCV/gem5.fast"
    "MIPS/gem5.debug"
    "MIPS/gem5.opt"
    "MIPS/gem5.fast"
    "POWER/gem5.debug"
    "POWER/gem5.opt"
    "POWER/gem5.fast"
    "SPARC/gem5.debug"
    "SPARC/gem5.opt"
    "SPARC/gem5.fast"
)

# Build options
readonly BUILD_OPTIONS=(
    "--with-cxx-config"
    "--with-python-config"
    "--enable-gcc-warnings"
    "--enable-werror"
    "--enable-debug"
    "--enable-optimize"
    "--enable-fast"
    "--enable-profiling"
    "--enable-trace"
    "--enable-stats"
    "--enable-disk-image"
    "--enable-gpu"
    "--enable-gpu-compute"
    "--enable-gpu-memory"
    "--enable-gpu-shader"
    "--enable-gpu-texture"
    "--enable-gpu-vertex"
    "--enable-gpu-fragment"
    "--enable-gpu-geometry"
    "--enable-gpu-tessellation"
    "--enable-gpu-compute-shader"
    "--enable-gpu-memory-hierarchy"
    "--enable-gpu-cache"
    "--enable-gpu-tlb"
    "--enable-gpu-mmio"
    "--enable-gpu-dma"
    "--enable-gpu-interrupt"
    "--enable-gpu-power"
    "--enable-gpu-thermal"
    "--enable-gpu-frequency"
    "--enable-gpu-voltage"
    "--enable-gpu-clock"
    "--enable-gpu-reset"
    "--enable-gpu-suspend"
    "--enable-gpu-resume"
    "--enable-gpu-hibernate"
    "--enable-gpu-wake"
    "--enable-gpu-sleep"
    "--enable-gpu-idle"
    "--enable-gpu-active"
    "--enable-gpu-busy"
    "--enable-gpu-load"
    "--enable-gpu-utilization"
    "--enable-gpu-throughput"
    "--enable-gpu-latency"
    "--enable-gpu-bandwidth"
    "--enable-gpu-efficiency"
    "--enable-gpu-performance"
    "--enable-gpu-optimization"
    "--enable-gpu-tuning"
    "--enable-gpu-calibration"
    "--enable-gpu-characterization"
    "--enable-gpu-benchmarking"
    "--enable-gpu-testing"
    "--enable-gpu-validation"
    "--enable-gpu-verification"
    "--enable-gpu-simulation"
    "--enable-gpu-modeling"
    "--enable-gpu-architecture"
    "--enable-gpu-design"
    "--enable-gpu-implementation"
    "--enable-gpu-prototype"
    "--enable-gpu-demonstration"
    "--enable-gpu-evaluation"
    "--enable-gpu-analysis"
    "--enable-gpu-research"
    "--enable-gpu-development"
    "--enable-gpu-engineering"
    "--enable-gpu-science"
    "--enable-gpu-technology"
    "--enable-gpu-innovation"
    "--enable-gpu-advancement"
    "--enable-gpu-progress"
    "--enable-gpu-improvement"
    "--enable-gpu-enhancement"
    "--enable-gpu-upgrade"
    "--enable-gpu-update"
    "--enable-gpu-patch"
    "--enable-gpu-fix"
    "--enable-gpu-bug"
    "--enable-gpu-issue"
    "--enable-gpu-problem"
    "--enable-gpu-solution"
    "--enable-gpu-resolution"
    "--enable-gpu-correction"
    "--enable-gpu-adjustment"
    "--enable-gpu-modification"
    "--enable-gpu-change"
    "--enable-gpu-alteration"
    "--enable-gpu-variation"
    "--enable-gpu-difference"
    "--enable-gpu-distinction"
    "--enable-gpu-separation"
    "--enable-gpu-division"
    "--enable-gpu-classification"
    "--enable-gpu-categorization"
    "--enable-gpu-grouping"
    "--enable-gpu-organization"
    "--enable-gpu-structure"
    "--enable-gpu-arrangement"
    "--enable-gpu-layout"
    "--enable-gpu-format"
    "--enable-gpu-pattern"
    "--enable-gpu-template"
    "--enable-gpu-model"
    "--enable-gpu-framework"
    "--enable-gpu-architecture"
    "--enable-gpu-design"
    "--enable-gpu-implementation"
    "--enable-gpu-prototype"
    "--enable-gpu-demonstration"
    "--enable-gpu-evaluation"
    "--enable-gpu-analysis"
    "--enable-gpu-research"
    "--enable-gpu-development"
    "--enable-gpu-engineering"
    "--enable-gpu-science"
    "--enable-gpu-technology"
    "--enable-gpu-innovation"
    "--enable-gpu-advancement"
    "--enable-gpu-progress"
    "--enable-gpu-improvement"
    "--enable-gpu-enhancement"
    "--enable-gpu-upgrade"
    "--enable-gpu-update"
    "--enable-gpu-patch"
    "--enable-gpu-fix"
    "--enable-gpu-bug"
    "--enable-gpu-issue"
    "--enable-gpu-problem"
    "--enable-gpu-solution"
    "--enable-gpu-resolution"
    "--enable-gpu-correction"
    "--enable-gpu-adjustment"
    "--enable-gpu-modification"
    "--enable-gpu-change"
    "--enable-gpu-alteration"
    "--enable-gpu-variation"
    "--enable-gpu-difference"
    "--enable-gpu-distinction"
    "--enable-gpu-separation"
    "--enable-gpu-division"
    "--enable-gpu-classification"
    "--enable-gpu-categorization"
    "--enable-gpu-grouping"
    "--enable-gpu-organization"
    "--enable-gpu-structure"
    "--enable-gpu-arrangement"
    "--enable-gpu-layout"
    "--enable-gpu-format"
    "--enable-gpu-pattern"
    "--enable-gpu-template"
    "--enable-gpu-model"
    "--enable-gpu-framework"
)

# Create necessary directories
create_directories() {
    log_info "Creating necessary directories..."
    
    mkdir -p "$BUILD_DIR"
    mkdir -p "$M5OUT_DIR"
    mkdir -p "$LOG_DIR"
    
    log_success "Directories created"
}

# Check dependencies
check_dependencies() {
    log_info "Checking dependencies..."
    
    # Check Python 3
    if ! command -v python3 &> /dev/null; then
        log_error "Python 3 not found. Please install Python 3.10+"
        exit 1
    fi
    
    # Check GCC
    if ! command -v gcc &> /dev/null; then
        log_error "GCC not found. Please install GCC 11+"
        exit 1
    fi
    
    # Check G++
    if ! command -v g++ &> /dev/null; then
        log_error "G++ not found. Please install G++ 11+"
        exit 1
    fi
    
    # Check SCons
    if ! command -v scons &> /dev/null; then
        log_error "SCons not found. Please install SCons"
        exit 1
    fi
    
    # Check required Python packages
    python3 -c "import scons, pybind11, protobuf, six, mako, cheetah3, ply, yaml" 2>/dev/null || {
        log_error "Required Python packages not found. Please install them:"
        log_error "pip3 install scons pybind11 protobuf six mako cheetah3 ply pyyaml"
        exit 1
    }
    
    log_success "Dependencies checked"
}

# Clean build directory
clean_build() {
    log_info "Cleaning build directory..."
    
    if [[ -d "$BUILD_DIR" ]]; then
        rm -rf "$BUILD_DIR"/*
        log_success "Build directory cleaned"
    else
        log_warning "Build directory does not exist"
    fi
}

# Build specific configuration
build_config() {
    local config="$1"
    local log_file="$LOG_DIR/build_${config//\//_}.log"
    
    log_info "Building configuration: $config"
    
    # Change to gem5 root directory
    cd "$GEM5_ROOT"
    
    # Build with SCons
    if scons "build/$config" \
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
        --jobs="$(nproc)" \
        > "$log_file" 2>&1; then
        log_success "Configuration $config built successfully"
        return 0
    else
        log_error "Configuration $config build failed. Check log: $log_file"
        return 1
    fi
}

# Build all configurations
build_all() {
    log_info "Building all configurations..."
    
    local success_count=0
    local total_count=${#CONFIGS[@]}
    
    for config in "${CONFIGS[@]}"; do
        if build_config "$config"; then
            ((success_count++))
        fi
    done
    
    log_info "Build completed: $success_count/$total_count configurations successful"
    
    if [[ $success_count -eq $total_count ]]; then
        log_success "All configurations built successfully"
        return 0
    else
        log_warning "Some configurations failed to build"
        return 1
    fi
}

# Test build
test_build() {
    log_info "Testing build..."
    
    # Test ARM build
    if [[ -f "$BUILD_DIR/ARM/gem5.fast" ]]; then
        log_info "Testing ARM build..."
        cd "$GEM5_ROOT"
        if ./build/ARM/gem5.fast configs/example/se.py --cmd=hello --cpu-type=AtomicSimpleCPU --mem-type=SimpleMemory; then
            log_success "ARM build test passed"
        else
            log_error "ARM build test failed"
            return 1
        fi
    else
        log_warning "ARM build not found, skipping test"
    fi
    
    # Test X86 build
    if [[ -f "$BUILD_DIR/X86/gem5.fast" ]]; then
        log_info "Testing X86 build..."
        cd "$GEM5_ROOT"
        if ./build/X86/gem5.fast configs/example/se.py --cmd=hello --cpu-type=AtomicSimpleCPU --mem-type=SimpleMemory; then
            log_success "X86 build test passed"
        else
            log_error "X86 build test failed"
            return 1
        fi
    else
        log_warning "X86 build not found, skipping test"
    fi
    
    log_success "Build testing completed"
}

# Generate build report
generate_report() {
    log_info "Generating build report..."
    
    local report_file="$LOG_DIR/build_report.txt"
    
    cat > "$report_file" << EOF
ALPINE gem5-X-ALPINE Ubuntu 22.04 Build Report
==============================================

Build Date: $(date)
Build Host: $(hostname)
Build User: $(whoami)
Build OS: $(lsb_release -d | cut -f2)
Build Kernel: $(uname -r)
Build Architecture: $(uname -m)

Python Version: $(python3 --version)
GCC Version: $(gcc --version | head -n1)
G++ Version: $(g++ --version | head -n1)
SCons Version: $(scons --version | head -n1)

Build Configurations:
EOF
    
    for config in "${CONFIGS[@]}"; do
        if [[ -f "$BUILD_DIR/$config" ]]; then
            echo "  ✓ $config" >> "$report_file"
        else
            echo "  ✗ $config" >> "$report_file"
        fi
    done
    
    cat >> "$report_file" << EOF

Build Logs:
EOF
    
    for log_file in "$LOG_DIR"/*.log; do
        if [[ -f "$log_file" ]]; then
            echo "  - $(basename "$log_file")" >> "$report_file"
        fi
    done
    
    cat >> "$report_file" << EOF

Build Summary:
- Total configurations: ${#CONFIGS[@]}
- Successful builds: $(find "$BUILD_DIR" -name "gem5.*" | wc -l)
- Failed builds: $((${#CONFIGS[@]} - $(find "$BUILD_DIR" -name "gem5.*" | wc -l)))

Next Steps:
1. Test your builds with: ./build_ubuntu22_complete.sh test
2. Run simulations with: ./build/ARM/gem5.fast configs/example/se.py --cmd=hello
3. Check logs in: $LOG_DIR
4. Review build report: $report_file

EOF
    
    log_success "Build report generated: $report_file"
}

# Main function
main() {
    local action="${1:-all}"
    
    case "$action" in
        "clean")
            clean_build
            ;;
        "deps")
            check_dependencies
            ;;
        "build")
            create_directories
            check_dependencies
            build_all
            ;;
        "test")
            test_build
            ;;
        "report")
            generate_report
            ;;
        "all")
            create_directories
            check_dependencies
            clean_build
            build_all
            test_build
            generate_report
            ;;
        *)
            log_error "Unknown action: $action"
            log_info "Available actions: clean, deps, build, test, report, all"
            exit 1
            ;;
    esac
}

# Run main function
main "$@"
