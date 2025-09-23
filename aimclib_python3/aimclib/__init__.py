#!/usr/bin/env python3
"""
ALPINE AIMC Library - Python 3 Implementation

This package provides a Python 3 implementation of the ALPINE AIMC (Analog In-Memory Computing)
library, originally written in C++. The library supports matrix-vector multiplication operations
optimized for analog computing hardware.

Compatible with Python 3.8+ and Ubuntu 22.04 with GCC 11.
"""

from .aimc import *

__version__ = "1.0.0"
__author__ = "Joshua Klein"
__copyright__ = "Copyright EPFL 2021"
__license__ = "MIT"

# Package metadata
__title__ = "alpine-aimc"
__description__ = "ALPINE AIMC Library - Python 3 implementation for Analog In-Memory Computing"
__url__ = "https://github.com/epfl-alpine/aimc-library"
__email__ = "joshua.klein@epfl.ch"

# Export version information
__all__ = [
    "__version__",
    "__author__", 
    "__copyright__",
    "__license__",
    "__title__",
    "__description__",
    "__url__",
    "__email__"
]
