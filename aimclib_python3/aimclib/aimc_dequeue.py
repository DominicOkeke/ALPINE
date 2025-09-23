#!/usr/bin/env python3
"""
Copyright EPFL 2021
Joshua Klein

This file contains functions for dequeueing larger data structures.

TODO: Add in activation functions for optimized dequeue utilization.
"""

import numpy as np
from typing import List, Union, TypeVar, Generic
from .aimc_check import aimc_dequeue

T = TypeVar('T', bound=Union[int, float])


def dequeue_vector(size: int, v: List[int], tid: int = 0) -> None:
    """
    int8_t vector dequeueing into array.
    
    Args:
        size: Size of the vector
        v: List to store dequeued values (will be modified)
        tid: Thread ID (default: 0)
    """
    # For Python implementation, we'll use the packed approach
    tmp = 0
    ptmp = 0
    
    for i in range(size):
        if i % 4 == 0:
            tmp = aimc_dequeue(tid)
            ptmp = tmp
        
        v[i] = ptmp & 0xff
        ptmp >>= 8


def dequeue_vector_scaled(size: int, max_val: T, v: List[T], tid: int = 0) -> None:
    """
    Vector dequeueing for higher precision, scaled according to max.
    
    Args:
        size: Size of the vector
        max_val: Maximum value for scaling
        v: List to store dequeued values (will be modified)
        tid: Thread ID (default: 0)
    """
    # For Python implementation, we'll use the packed approach
    tmp = 0
    ptmp = 0
    
    for i in range(size):
        if i % 4 == 0:
            tmp = aimc_dequeue(tid)
            ptmp = tmp
        
        # Scale the value back from int8 range
        scaled_val = (ptmp & 0xff) / 127 * max_val
        v[i] = scaled_val
        ptmp >>= 8


def dequeue_numpy_vector(size: int, tid: int = 0) -> np.ndarray:
    """
    Dequeue a vector into a numpy array.
    
    Args:
        size: Size of the vector to dequeue
        tid: Thread ID (default: 0)
    
    Returns:
        Numpy array containing dequeued values
    """
    v = np.zeros(size, dtype=np.int8)
    dequeue_vector(size, v.tolist(), tid)
    return v


def dequeue_numpy_vector_scaled(size: int, max_val: T, tid: int = 0) -> np.ndarray:
    """
    Dequeue a scaled vector into a numpy array.
    
    Args:
        size: Size of the vector to dequeue
        max_val: Maximum value for scaling
        tid: Thread ID (default: 0)
    
    Returns:
        Numpy array containing dequeued values
    """
    v = np.zeros(size, dtype=np.float64)
    dequeue_vector_scaled(size, max_val, v.tolist(), tid)
    return v


def dequeue_vector_loosely_coupled(size: int, v: List[int], tid: int = 0) -> None:
    """
    int8_t vector dequeueing for loosely coupled MMIO mode.
    
    Args:
        size: Size of the vector
        v: List to store dequeued values (will be modified)
        tid: Thread ID (default: 0)
    """
    for i in range(size):
        v[i] = aimc_dequeue(tid)


def dequeue_vector_scaled_loosely_coupled(size: int, max_val: T, v: List[T], tid: int = 0) -> None:
    """
    Scaled vector dequeueing for loosely coupled MMIO mode.
    
    Args:
        size: Size of the vector
        max_val: Maximum value for scaling
        v: List to store dequeued values (will be modified)
        tid: Thread ID (default: 0)
    """
    for i in range(size):
        v[i] = (aimc_dequeue(tid)) / 127 * max_val
