# ALPINE AIMC Library - C++17 Version

This is the C++17 updated version of the ALPINE AIMC (Analog In-Memory Computing) library, optimized for GCC 11 on Ubuntu 22.04.

## Features

- **C++17 Standard**: Full C++17 compliance with modern language features
- **Smart Pointers**: Automatic memory management with `std::unique_ptr`
- **Const Correctness**: Proper use of `const` and `constexpr`
- **Type Safety**: Enhanced type safety with explicit casting
- **Performance**: Optimized for GCC 11 with native architecture tuning
- **Modern C++**: Uses range-based loops, auto keyword, and other C++17 features

## Requirements

- **Compiler**: GCC 11 or later (tested on Ubuntu 22.04)
- **Standard**: C++17 support
- **OS**: Ubuntu 22.04 (recommended) or compatible Linux distribution

## Installation

### Prerequisites

```bash
# Update package list
sudo apt update

# Install GCC 11 and build tools
sudo apt install gcc-11 g++-11 build-essential

# Set GCC 11 as default (optional)
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-11 100
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-11 100
```

### Building

```bash
# Make build script executable
chmod +x build_example.sh

# Build the examples
./build_example.sh
```

## C++17 Features Used

### Smart Pointers
```cpp
// Old C++ style
int8_t* data = new int8_t[size];
delete[] data;

// C++17 style
auto data = std::make_unique<int8_t[]>(size);
// Automatic cleanup
```

### Constexpr Functions
```cpp
// Compile-time evaluation
constexpr uint64_t aimcProcess(int tid = 0) noexcept
{
    // Function body
}
```

### Modern Initialization
```cpp
// C++17: Brace initialization and auto
constexpr int width = 4000;
constexpr int height = 4000;
auto core = std::make_unique<AnalogComputationalMemoryCore>();
```

### Type Safety
```cpp
// Explicit casting for better type safety
auto scaled_val = static_cast<int8_t>((value / max) * 127);
```

## API Changes from Original

### Memory Management
- **Old**: Manual `new`/`delete` with raw pointers
- **New**: Smart pointers with automatic memory management

### Function Signatures
- **Old**: `void function(int* data)`
- **New**: `void function(const int8_t* data) noexcept`

### Compilation
- **Old**: `g++ -O3 example.cc`
- **New**: `g++ -std=c++17 -Wall -Wextra -O3 example.cc`

## Performance Improvements

1. **Compiler Optimizations**: Uses `-march=native -mtune=native` for target architecture
2. **Memory Safety**: Eliminates memory leaks with smart pointers
3. **Const Correctness**: Enables better compiler optimizations
4. **Modern Algorithms**: Uses `std::fill` and `std::clamp` for better performance

## Example Usage

```cpp
#include "aimc.hh"
#include <iostream>
#include <memory>

int main() {
    // C++17: Use smart pointers
    constexpr int size = 1024;
    auto weights = std::make_unique<int8_t[]>(size * size);
    auto input = std::make_unique<int8_t[]>(size);
    auto output = std::make_unique<int8_t[]>(size);
    
    // Initialize with random data
    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_int_distribution<int8_t> dis(-128, 127);
    
    for (int i = 0; i < size * size; i++) {
        weights[i] = dis(gen);
    }
    
    for (int i = 0; i < size; i++) {
        input[i] = dis(gen);
    }
    
    // Map weights to AIMC core
    mapMatrix(0, 0, size, size, weights.get());
    
    // Queue input
    queueVector(size, input.get());
    
    // Process
    aimcProcess();
    
    // Dequeue output
    dequeueVector(size, output.get());
    
    // Smart pointers automatically clean up
    return 0;
}
```

## Compilation Flags

The build script uses the following C++17 flags:

```bash
-std=c++17          # C++17 standard
-Wall               # Enable all warnings
-Wextra             # Extra warnings
-Wpedantic          # Strict ISO C++ compliance
-O3                 # Maximum optimization
-march=native       # Optimize for current CPU
-mtune=native       # Tune for current CPU
```

## Troubleshooting

### Common Issues

1. **GCC Version Too Old**
   ```bash
   # Check version
   g++ --version
   
   # Install GCC 11
   sudo apt install gcc-11 g++-11
   ```

2. **C++17 Features Not Recognized**
   ```bash
   # Ensure C++17 flag is used
   g++ -std=c++17 your_file.cc
   ```

3. **Memory Issues**
   - The C++17 version uses smart pointers, eliminating most memory leaks
   - Use `valgrind` to check for remaining issues

### Debugging

```bash
# Build with debug symbols
g++ -std=c++17 -g -O0 -DDEBUG example.cc -o example_debug

# Run with valgrind
valgrind --leak-check=full ./example_debug
```

## Migration from Original Version

1. **Replace raw pointers** with smart pointers
2. **Add const correctness** to function parameters
3. **Use constexpr** for compile-time constants
4. **Add noexcept** to functions that don't throw
5. **Update compilation flags** to include C++17

## Performance Comparison

| Feature | Original C++ | C++17 Version |
|---------|-------------|---------------|
| Memory Safety | Manual | Automatic |
| Compile Time | Standard | Optimized |
| Runtime Safety | Basic | Enhanced |
| Code Clarity | Good | Excellent |
| Maintenance | Manual | Automatic |

## Contributing

When contributing to the C++17 version:

1. Follow C++17 best practices
2. Use smart pointers for memory management
3. Add `const` and `constexpr` where appropriate
4. Include `noexcept` for non-throwing functions
5. Use modern C++ algorithms and containers

## License

Copyright EPFL 2021 - MIT License

## Changelog

### Version 2.0.0 (C++17)
- Updated to C++17 standard
- Replaced raw pointers with smart pointers
- Added const correctness throughout
- Enhanced type safety
- Improved performance with modern optimizations
- Updated build system for GCC 11
- Added comprehensive error checking
