# ALPINE AIMC Library - Python 3 Implementation

This is a Python 3 implementation of the ALPINE AIMC (Analog In-Memory Computing) library, originally written in C++. The library provides optimized matrix-vector multiplication operations for analog computing hardware.

## Features

- **Python 3.8+ Support**: Compatible with Ubuntu 22.04 and modern Python versions
- **NumPy Integration**: Seamless integration with NumPy arrays for efficient computation
- **Type Hints**: Full type annotation support for better IDE integration
- **Modular Design**: Clean separation of concerns with individual modules for different operations
- **Simulation Mode**: Built-in simulation capabilities for testing and development
- **Hardware Interface**: Support for actual hardware intrinsics when available

## Requirements

- Python 3.8 or higher
- NumPy 1.21.0 or higher
- Ubuntu 22.04 (recommended)
- GCC 11 (for C++ extensions, if needed)

## Installation

### From Source

```bash
# Clone the repository
git clone <repository-url>
cd ALPINE/aimclib

# Install dependencies
pip3 install -r requirements.txt

# Install in development mode
pip3 install -e .
```

### Using pip

```bash
pip3 install alpine-aimc
```

## Quick Start

```python
import numpy as np
from aimc import AnalogComputationalMemory, map_matrix, queue_vector, dequeue_vector, aimc_process

# Initialize AIMC system
aimc = AnalogComputationalMemory(num_cores=1)

# Create a weight matrix
weights = np.random.randint(-128, 127, size=(1024, 1024), dtype=np.int8)

# Map weights to AIMC core
map_matrix(0, 0, weights)

# Create input vector
input_vec = np.random.randint(-128, 127, size=1024, dtype=np.int8)

# Queue input
queue_vector(1024, input_vec)

# Perform matrix-vector multiplication
aimc_process()

# Dequeue result
output_vec = np.zeros(1024, dtype=np.int8)
dequeue_vector(1024, output_vec)

print(f"Input shape: {input_vec.shape}")
print(f"Output shape: {output_vec.shape}")
```

## Running the Example

```bash
# Make the build script executable
chmod +x build_example_python.sh

# Run the example
./build_example_python.sh
```

Or run directly:

```bash
python3 example.py
```

## API Reference

### Core Classes

#### `AnalogComputationalMemoryCore`
Represents a single AIMC core with configurable dimensions.

```python
core = AnalogComputationalMemoryCore(crossbar_height=4000, crossbar_width=4000)
```

#### `AnalogComputationalMemory`
Manages multiple AIMC cores.

```python
aimc = AnalogComputationalMemory(num_cores=8)
```

### Matrix Operations

#### `map_matrix(aimc_x, aimc_y, matrix)`
Map a NumPy matrix to AIMC core coordinates.

#### `queue_vector(size, vector)`
Queue a vector for processing.

#### `dequeue_vector(size, vector)`
Dequeue processed results.

#### `aimc_process(tid=0)`
Perform matrix-vector multiplication.

### Advanced Operations

#### Scaled Operations
For higher precision with automatic scaling:

```python
from aimc import queue_vector_scaled, dequeue_vector_scaled

# Queue with scaling
queue_vector_scaled(size, max_value, vector)

# Dequeue with scaling
dequeue_vector_scaled(size, max_value, vector)
```

#### Loosely Coupled MMIO
For different memory access patterns:

```python
from aimc import dequeue_vector_loosely_coupled

dequeue_vector_loosely_coupled(size, vector)
```

## Architecture

The library is organized into several modules:

- **`aimc_check.py`**: Core AIMC simulation and emulation
- **`aimc_queue.py`**: Vector queueing operations
- **`aimc_dequeue.py`**: Vector dequeueing operations  
- **`aimc_tile.py`**: Matrix mapping and tiling
- **`aimc_intrinsics.py`**: Hardware intrinsics interface
- **`aimc.py`**: Main module with all exports

## Performance Considerations

- Use NumPy arrays for best performance
- Consider memory layout when working with large matrices
- The library includes both packed and unpacked vector operations
- Simulation mode is useful for development and testing

## Development

### Running Tests

```bash
python3 -m pytest
```

### Code Formatting

```bash
black aimclib/
```

### Linting

```bash
flake8 aimclib/
```

## Migration from C++

The Python API closely mirrors the C++ interface:

| C++ | Python |
|-----|--------|
| `#include "aimc.hh"` | `from aimc import *` |
| `AnalogComputationalMemory aimc(8)` | `aimc = AnalogComputationalMemory(8)` |
| `aimcProcess()` | `aimc_process()` |
| `queueVector(size, v)` | `queue_vector(size, v)` |
| `dequeueVector(size, v)` | `dequeue_vector(size, v)` |

## Troubleshooting

### Common Issues

1. **Import Errors**: Ensure you're using Python 3.8+ and have installed dependencies
2. **NumPy Issues**: Update NumPy to version 1.21.0 or higher
3. **Memory Issues**: For large matrices, consider using smaller chunks or different data types

### Getting Help

- Check the example code in `example.py`
- Review the API documentation above
- Check GitHub issues for known problems

## License

Copyright EPFL 2021 - MIT License

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## Changelog

### Version 1.0.0
- Initial Python 3 implementation
- Full API compatibility with C++ version
- NumPy integration
- Type hints and documentation
- Example and build scripts
