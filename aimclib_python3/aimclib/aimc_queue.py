#!/usr/bin/env python3
"""
Copyright EPFL 2021
Joshua Klein

This file contains functions for queueing larger data structures.
"""

import numpy as np
from typing import List, Union, TypeVar, Generic
from .aimc_check import aimc_queue

T = TypeVar('T', bound=Union[int, float])


def queue_vector(size: int, v: List[int], tid: int = 0) -> None:
    """
    int8_t vector queueing.
    
    Args:
        size: Size of the vector
        v: List of int8_t values to queue
        tid: Thread ID (default: 0)
    """
    # For Python implementation, we'll use the packed approach
    # Pack 4 int8 values into a 32-bit integer and queue into AIMC input memory
    tmp = 0
    
    for i in range(size):
        if (i % 4 == 0) and i > 0:
            aimc_queue(tmp, tid)
            tmp = 0
        
        tmp |= (v[i] & 0xff) << (8 * (i % 4))
    
    # Queue the leftover values, in case |v| % 4 != 0
    aimc_queue(tmp, tid)


def queue_vector_scaled(size: int, max_val: T, v: List[T], tid: int = 0) -> None:
    """
    Vector queueing for higher precision, scaled according to max.
    
    Args:
        size: Size of the vector
        max_val: Maximum value for scaling
        v: List of values to queue (will be scaled)
        tid: Thread ID (default: 0)
    """
    # For Python implementation, we'll use the packed approach
    tmp = 0
    
    # Pack 4 int8 values into tmp, and queue into AIMC input memory
    for i in range(size):
        if (i % 4 == 0) and i > 0:
            aimc_queue(tmp, tid)
            tmp = 0
        
        # Scale the value and convert to int8
        scaled_val = int(v[i] / max_val * 127)
        tmp |= (scaled_val & 0xff) << (8 * (i % 4))
    
    # Queue the leftover values, in case |v| % 4 != 0
    aimc_queue(tmp, tid)


def queue_numpy_vector(v: np.ndarray, tid: int = 0) -> None:
    """
    Queue a numpy array as a vector.
    
    Args:
        v: Numpy array to queue
        tid: Thread ID (default: 0)
    """
    if v.dtype != np.int8:
        v = v.astype(np.int8)
    
    queue_vector(len(v), v.tolist(), tid)


def queue_numpy_vector_scaled(v: np.ndarray, max_val: T, tid: int = 0) -> None:
    """
    Queue a numpy array as a vector with scaling.
    
    Args:
        v: Numpy array to queue
        max_val: Maximum value for scaling
        tid: Thread ID (default: 0)
    """
    queue_vector_scaled(len(v), max_val, v.tolist(), tid)
