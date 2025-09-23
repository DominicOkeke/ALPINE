#!/usr/bin/env python3
"""
Copyright EPFL 2021
Joshua Klein

This file contains functions for mapping and tiling matrices to the AIMC
core using parameter write intrinsics.
"""

import numpy as np
from typing import List, Union, TypeVar, Generic
from .aimc_check import aimc_param_write

T = TypeVar('T', bound=Union[int, float])


def map_matrix_int8(aimc_x: int, aimc_y: int, height: int, width: int, m: List[List[int]]) -> None:
    """
    Map int8_t matrix to AIMC core, where the top left corner (0, 0) of the
    matrix starts at (aimc_x, aimc_y) within the core.
    
    TODO/NOTE: There are no bounds checks!
    
    Args:
        aimc_x: X coordinate in AIMC core
        aimc_y: Y coordinate in AIMC core
        height: Height of the matrix
        width: Width of the matrix
        m: 2D list of int8_t values
    """
    for i in range(width):
        for j in range(height):
            aimc_param_write(i + aimc_x, j + aimc_y, m[j][i])


def map_matrix_scaled(aimc_x: int, aimc_y: int, height: int, width: int, max_val: T, m: List[List[T]]) -> None:
    """
    Map T matrix to AIMC core, where the top left corner (0, 0) of the
    matrix starts at (aimc_x, aimc_y) within the core. The values are scaled
    to int8_t according to the maximum.
    
    TODO/NOTE: There are no bounds checks!
    
    Args:
        aimc_x: X coordinate in AIMC core
        aimc_y: Y coordinate in AIMC core
        height: Height of the matrix
        width: Width of the matrix
        max_val: Maximum value for scaling
        m: 2D list of values to be scaled
    """
    for i in range(width):
        for j in range(height):
            scaled_val = int(m[j][i] / max_val * 127)
            aimc_param_write(i + aimc_x, j + aimc_y, scaled_val)


def map_matrix_flat_int8(aimc_x: int, aimc_y: int, height: int, width: int, m: List[int]) -> None:
    """
    Map int8_t flattened matrix to AIMC core, where the top left corner (0, 0)
    of the matrix starts at (aimc_x, aimc_y) within the core.
    
    TODO/NOTE: There are no bounds checks!
    
    Args:
        aimc_x: X coordinate in AIMC core
        aimc_y: Y coordinate in AIMC core
        height: Height of the matrix
        width: Width of the matrix
        m: Flattened list of int8_t values (row-major order)
    """
    for i in range(width):
        for j in range(height):
            aimc_param_write(i + aimc_x, j + aimc_y, m[i * width + j])


def map_matrix_flat_scaled(aimc_x: int, aimc_y: int, height: int, width: int, max_val: T, m: List[T]) -> None:
    """
    Map T flattened matrix to AIMC core, where the top left corner (0, 0) of the
    matrix starts at (aimc_x, aimc_y) within the core. The values are scaled
    to int8_t according to the maximum.
    
    TODO/NOTE: There are no bounds checks!
    
    Args:
        aimc_x: X coordinate in AIMC core
        aimc_y: Y coordinate in AIMC core
        height: Height of the matrix
        width: Width of the matrix
        max_val: Maximum value for scaling
        m: Flattened list of values to be scaled (row-major order)
    """
    for i in range(width):
        for j in range(height):
            scaled_val = int(m[i * width + j] / max_val * 127)
            aimc_param_write(i + aimc_x, j + aimc_y, scaled_val)


def map_numpy_matrix(aimc_x: int, aimc_y: int, m: np.ndarray) -> None:
    """
    Map numpy matrix to AIMC core.
    
    Args:
        aimc_x: X coordinate in AIMC core
        aimc_y: Y coordinate in AIMC core
        m: Numpy array (2D)
    """
    height, width = m.shape
    if m.dtype == np.int8:
        map_matrix_flat_int8(aimc_x, aimc_y, height, width, m.flatten().tolist())
    else:
        max_val = np.max(np.abs(m))
        map_matrix_flat_scaled(aimc_x, aimc_y, height, width, max_val, m.flatten().tolist())


def map_numpy_matrix_scaled(aimc_x: int, aimc_y: int, m: np.ndarray, max_val: T) -> None:
    """
    Map numpy matrix to AIMC core with explicit scaling.
    
    Args:
        aimc_x: X coordinate in AIMC core
        aimc_y: Y coordinate in AIMC core
        m: Numpy array (2D)
        max_val: Maximum value for scaling
    """
    height, width = m.shape
    map_matrix_flat_scaled(aimc_x, aimc_y, height, width, max_val, m.flatten().tolist())
