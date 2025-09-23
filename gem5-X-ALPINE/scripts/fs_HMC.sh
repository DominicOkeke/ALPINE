#!/bin/bash
# ALPINE gem5-X-ALPINE HMC Simulation Script
# Updated for Ubuntu 22.04 with modern bash standards

set -euo pipefail  # Exit on error, undefined vars, pipe failures

# Configuration for Ubuntu 22.04
export M5_PATH="${M5_PATH:-$HOME/gem5}"

# CPU Configuration
readonly MAIN_CPUS=4
readonly ALT_CPUS=0
readonly NUM_CPUS=$((MAIN_CPUS + ALT_CPUS))

# Paths for Ubuntu 22.04
readonly GEM5_ROOT="$(dirname "$(dirname "$(realpath "$0")")")"
readonly DTB="${GEM5_ROOT}/system/arm/dt/armv8_gem5_v1_${MAIN_CPUS}cpu.dtb"
readonly KERNEL="vmlinux_wa"
readonly CPU_TYPE="AtomicSimpleCPU"
readonly ALT_CPU_TYPE="AtomicSimpleCPU"
readonly DISK="test_kvazaar.img"
readonly DDR_SIZE="2GB"


# Check if gem5 binary exists
if [[ ! -f "${GEM5_ROOT}/build/ARM/gem5.fast" ]]; then
    echo "Error: gem5.fast not found. Please build gem5 first:"
    echo "  cd ${GEM5_ROOT}"
    echo "  scons build/ARM/gem5.fast"
    exit 1
fi

# Check if DTB file exists
if [[ ! -f "$DTB" ]]; then
    echo "Error: DTB file not found: $DTB"
    echo "Please ensure the device tree blob is available."
    exit 1
fi

echo "Starting ALPINE gem5-X-ALPINE HMC Simulation"
echo "============================================="
echo "Main CPUs: $MAIN_CPUS"
echo "Alt CPUs: $ALT_CPUS"
echo "DTB: $DTB"
echo "Kernel: $KERNEL"
echo "CPU Type: $CPU_TYPE"
echo "DDR Size: $DDR_SIZE"
echo ""

# Run gem5 simulation with modern argument handling
"${GEM5_ROOT}/build/ARM/gem5.fast" \
    "${GEM5_ROOT}/configs/fs_HMC_DDR/fs.py" \
    --machine-type=VExpress_GEM5_V1 \
    --kernel="$KERNEL" \
    --dtb="$DTB" \
    --main-num-cpus="$MAIN_CPUS" \
    --caches \
    --cpu-type="$CPU_TYPE" \
    --disk="$DISK" \
    --alt-cpu-type="$ALT_CPU_TYPE" \
    --ddr-size="$DDR_SIZE" \
    --alt-num-cpus="$ALT_CPUS" \
    --num-serial-links=5 \
    --no_ddr

# Optional parameters (uncomment as needed):
# --workload-automation-vio=/home/yqureshi/temp
# --checkpoint-restore=1 --restore-with-cpu="$CPU_TYPE"
# --restore-with-alt-cpu="$ALT_CPU_TYPE"
# --hmc-size="$HMC_SIZE"
# --command-line='earlyprintk=pl011,0x1c090000 console=ttyAMA0 lpj=19988480 norandmaps rw loglevel=8 mem=2G root=%(rootdev)s'
