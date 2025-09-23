#!/usr/bin/env python3
"""
Copyright EPFL 2021
Joshua Klein

This file contains all of the imports for which to build the AIMC library.
"""

import os
import sys

# Add the current directory to the Python path
sys.path.insert(0, os.path.dirname(__file__))

# Import all AIMC modules
from .aimc_check import (
    AnalogComputationalMemoryCore,
    AnalogComputationalMemory,
    aimc_process,
    aimc_queue,
    aimc_dequeue,
    aimc_param_read,
    aimc_param_write
)

from .aimc_queue import (
    queue_vector,
    queue_vector_scaled,
    queue_numpy_vector,
    queue_numpy_vector_scaled
)

from .aimc_dequeue import (
    dequeue_vector,
    dequeue_vector_scaled,
    dequeue_numpy_vector,
    dequeue_numpy_vector_scaled,
    dequeue_vector_loosely_coupled,
    dequeue_vector_scaled_loosely_coupled
)

from .aimc_tile import (
    map_matrix_int8,
    map_matrix_scaled,
    map_matrix_flat_int8,
    map_matrix_flat_scaled,
    map_numpy_matrix,
    map_numpy_matrix_scaled
)

from .aimc_intrinsics import (
    AIMCIntrinsics,
    aimc_process as aimc_process_intrinsic,
    aimc_queue as aimc_queue_intrinsic,
    aimc_dequeue as aimc_dequeue_intrinsic,
    aimc_param_read as aimc_param_read_intrinsic,
    aimc_param_write as aimc_param_write_intrinsic
)

# Version information
__version__ = "1.0.0"
__author__ = "Joshua Klein"
__copyright__ = "Copyright EPFL 2021"

# Convenience aliases for common functions
map_matrix = map_numpy_matrix
queue_vector = queue_numpy_vector
dequeue_vector = dequeue_numpy_vector

# Export all public functions and classes
__all__ = [
    # Core classes
    'AnalogComputationalMemoryCore',
    'AnalogComputationalMemory',
    
    # Basic operations
    'aimc_process',
    'aimc_queue', 
    'aimc_dequeue',
    'aimc_param_read',
    'aimc_param_write',
    
    # Queue operations
    'queue_vector',
    'queue_vector_scaled',
    'queue_numpy_vector',
    'queue_numpy_vector_scaled',
    
    # Dequeue operations
    'dequeue_vector',
    'dequeue_vector_scaled',
    'dequeue_numpy_vector',
    'dequeue_numpy_vector_scaled',
    'dequeue_vector_loosely_coupled',
    'dequeue_vector_scaled_loosely_coupled',
    
    # Matrix mapping operations
    'map_matrix_int8',
    'map_matrix_scaled',
    'map_matrix_flat_int8',
    'map_matrix_flat_scaled',
    'map_numpy_matrix',
    'map_numpy_matrix_scaled',
    'map_matrix',  # Alias for map_numpy_matrix
    
    # Intrinsics
    'AIMCIntrinsics',
    'aimc_process_intrinsic',
    'aimc_queue_intrinsic',
    'aimc_dequeue_intrinsic',
    'aimc_param_read_intrinsic',
    'aimc_param_write_intrinsic',
    
    # Version info
    '__version__',
    '__author__',
    '__copyright__'
]
