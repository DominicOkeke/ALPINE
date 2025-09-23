# ALPINE gem5-X-ALPINE Simulator

This is the ALPINE gem5-X-ALPINE simulator, updated for Ubuntu 22.04 with modern toolchain support.

## 🚀 Quick Start for Ubuntu 22.04

```bash
# 1. Automated setup
chmod +x setup_ubuntu22.sh
./setup_ubuntu22.sh

# 2. Build gem5
chmod +x build_ubuntu22.sh
./build_ubuntu22.sh

# 3. Run simulation
./scripts/fs_HMC.sh
```

## 📋 System Requirements

- **OS**: Ubuntu 22.04 LTS (Jammy Jellyfish)
- **GCC**: 11.0+ (default in Ubuntu 22.04)
- **Python**: 3.10+ (default in Ubuntu 22.04)
- **SCons**: 4.0+
- **SWIG**: 4.0+
- **Protobuf**: 3.0+

## 🛠️ Modern Features

- **C++17**: Full C++17 standard support
- **GCC 11**: Optimized compilation with native architecture tuning
- **Python 3.10+**: Modern Python features and performance
- **Smart Pointers**: Automatic memory management
- **Modern Shell**: Updated scripts with error handling and validation

## 📚 Documentation

- **README_UBUNTU22.md**: Comprehensive Ubuntu 22.04 guide
- **setup_ubuntu22.sh**: Automated environment setup
- **build_ubuntu22.sh**: Modern build system with options

## 🔧 Building

### Quick Build
```bash
./build_ubuntu22.sh
```

### Advanced Build Options
```bash
# X86 architecture with optimizations
./build_ubuntu22.sh -a X86 -t opt

# Debug build with verbose output
./build_ubuntu22.sh -d -v -t debug

# Clean build with 8 parallel jobs
./build_ubuntu22.sh -c -j 8
```

## 🚀 Running Simulations

### HMC Simulations
```bash
# Basic HMC simulation
./scripts/fs_HMC.sh

# Kvazaar workload
./scripts/fs_HMC_kvz.sh
```

## 🌐 Resources

- **Main Website**: http://www.gem5.org
- **Documentation**: http://www.gem5.org/Documentation
- **Tutorials**: http://www.gem5.org/Tutorials
- **Dependencies**: http://www.gem5.org/Dependencies

## 📁 Project Structure

```
gem5-X-ALPINE/
├── src/                    # Source code (C++17)
├── configs/               # Configuration files (Python 3.10+)
│   ├── fs_HMC_DDR/       # HMC DDR configurations
│   └── boot/             # Boot scripts (modern shell)
├── scripts/               # Shell scripts (bash with error handling)
├── util/                  # Utility programs (Python 3.10+)
├── setup_ubuntu22.sh     # Automated setup for Ubuntu 22.04
├── build_ubuntu22.sh     # Modern build system
└── README_UBUNTU22.md    # Comprehensive Ubuntu 22.04 guide
```

## 🔄 Updates

### Version 2.0.0 (Ubuntu 22.04)
- ✅ C++17 standard support
- ✅ GCC 11 optimizations
- ✅ Python 3.10+ compatibility
- ✅ Modern shell scripting
- ✅ Automated setup scripts
- ✅ Enhanced error handling
- ✅ Performance optimizations

### Migration from Previous Versions
1. Run `./setup_ubuntu22.sh` to update environment
2. Use `./build_ubuntu22.sh` instead of manual scons
3. Update Python scripts to use Python 3 syntax
4. Check shell scripts for modern bash features

## 🤝 Contributing

When contributing to the Ubuntu 22.04 version:

1. **C++ Code**: Follow C++17 best practices
2. **Python Code**: Use Python 3.10+ features
3. **Shell Scripts**: Use modern bash with error handling
4. **Documentation**: Update for Ubuntu 22.04 compatibility

## 📄 License

Copyright EPFL 2021 - MIT License

## 🆘 Support

For Ubuntu 22.04 specific issues:
1. Check `README_UBUNTU22.md`
2. Run `./setup_ubuntu22.sh` to verify environment
3. Use `./build_ubuntu22.sh -v` for verbose build output
4. Check system requirements and dependencies
