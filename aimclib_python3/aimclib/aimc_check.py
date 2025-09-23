#!/usr/bin/env python3
"""
Copyright EPFL 2021
Joshua Klein

This file contains classes and functions for which we can emulate and check
the code in the associated gem5 model. This model reflects an updated
model optimized for queueing and dequeueing: we assume that the control unit
of the AIMC core has two internal counters that can be used for the
addressing of the input and output memories.

The workflow of the core model is as follows:
- 1. Load your input vector into the input memory of the AIMC core model:
- - a. Scale your input values to 8-bit and apply a to make the values
       unsigned.
- - b. Write up to scaled inputs to register R, such that it is packed as
       <<input 3>, <input 2>, <input 1>, <input 0>> (note this example is
       for use with a 32-bit register).
- - c. Call the CM_QUEUE custom instruction so that it takes the values in
       R, and places them in the input memory. The first time this
       instruction is called, the AIMC control unit's input memory counter
       is set to 0, and so this value will be incremented by 4 in order to
       mean that 4 values have been "queued" in the input memory. The 4
       packed values will reside in the first four places of the AIMC core's
       input memory.
- - d. Call the CM_QUEUE custom instruction enough times so that the entire
       input vector resides in the input memory.
- 2. Perform the MVM in the AIMC CORE MODEL: Call the CM_PROCESS custom
     instruction once. This will perform A * B = C where A is the matrix
     held in the AIMC core, B is the vector in the input memory, and C is
     the output vector placed in the output memory. The CM_PROCESS custom
     also resets both the input and output memory control unit queueing
     counters as well as the input memory.
- 3. Read the output vector from the output memory of the AIMC core model:
- - a. Call the CM_DEQUEUE custom instruction to read from the output memory
       into register R. Assuming a 32-bit register, R will contain 4 and
       packed unsigned 8-bit integers from the first 4 output memory cells.
       The output memory control unit dequeueing counter will also increment
       by 4.
- - b. Repeat the CM_DEQUEUE instruction call until the entire output memory
       vector is retrieved. Note that the output values will need to be
       scaled back up from 8-bit.
"""

import numpy as np
from typing import List, Optional
import struct


class AnalogComputationalMemoryCore:
    """Core-Local AIMC Core implementation in Python 3."""
    
    def __init__(self, crossbar_height: int = 4000, crossbar_width: int = 4000):
        """Initialize the AIMC core with specified dimensions."""
        self.crossbar_height = crossbar_height
        self.crossbar_width = crossbar_width
        self.crossbar = np.zeros((crossbar_height, crossbar_width), dtype=np.int8)
        self.input_memory = np.zeros(crossbar_height, dtype=np.int8)
        self.output_memory = np.zeros(crossbar_width, dtype=np.int8)
        self.input_memory_counter = 0
        self.output_memory_counter = 0
        self.vectorization = 4

    def print_input_memory(self, limit: int = 10) -> None:
        """Helper for debugging - print input memory contents."""
        print(f"AIMC Core Input Memory =")
        for i in range(min(self.crossbar_height, limit)):
            if (i % 10) == 0 and i > 0:
                print()
            print(f"{self.input_memory[i]}\t", end="")
        print()

    def print_output_memory(self, limit: int = 10) -> None:
        """Helper for debugging - print output memory contents."""
        print(f"AIMC Core Output Memory =")
        for i in range(min(self.crossbar_width, limit)):
            if (i % 10) == 0 and i > 0:
                print()
            print(f"{self.output_memory[i]}\t", end="")
        print()

    def print_crossbar(self, limit: int = 10) -> None:
        """Helper for debugging - print crossbar contents."""
        print(f"AIMC Core Crossbar =")
        for i in range(min(self.crossbar_width, limit)):
            for j in range(min(limit, 10)):
                print(f"{self.crossbar[i, j]}\t", end="")
            print()
        print()

    def aimc_process(self) -> None:
        """Perform matrix-vector multiplication (MVM) operation."""
        for i in range(self.crossbar_width):
            acc = 0.0
            
            for j in range(self.crossbar_height):
                acc += self.input_memory[j] * self.crossbar[j, i]
            
            # Clamp to int8 range
            if acc > 127:
                self.output_memory[i] = 127
            elif acc < -128:
                self.output_memory[i] = -128
            else:
                self.output_memory[i] = int(acc)
        
        # Refresh input memory and queue counters
        self.input_memory.fill(0)
        self.input_memory_counter = 0
        self.output_memory_counter = 0

    def aimc_queue(self, val: int) -> None:
        """Queue values into input memory."""
        idx = self.input_memory_counter
        length = self.vectorization
        
        if (idx + length) < self.crossbar_height:
            for i in range(length):
                curr_val = (val >> (8 * i)) & 0xff
                self.input_memory[idx + i] = curr_val
        
        self.input_memory_counter += length

    def aimc_dequeue(self) -> int:
        """Dequeue values from output memory."""
        result = 0
        idx = self.output_memory_counter
        length = self.vectorization
        
        if (idx + length) < self.crossbar_width:
            for i in range(length - 1, -1, -1):
                result <<= 8
                result |= 0xff & self.output_memory[idx + i]
        
        self.output_memory_counter += length
        return result

    def aimc_param_read(self, x: int, y: int) -> int:
        """Read parameter from crossbar at position (x, y)."""
        if 0 <= x < self.crossbar_width and 0 <= y < self.crossbar_height:
            return self.crossbar[y, x]
        return 0

    def aimc_param_write(self, x: int, y: int, val: int) -> None:
        """Write parameter to crossbar at position (x, y)."""
        if 0 <= x < self.crossbar_width and 0 <= y < self.crossbar_height:
            self.crossbar[y, x] = val


class AnalogComputationalMemory:
    """AIMC Cores management class."""
    
    def __init__(self, num_cores: int = 1):
        """Initialize with specified number of cores."""
        self.cores: List[AnalogComputationalMemoryCore] = []
        for i in range(num_cores):
            self.cores.append(AnalogComputationalMemoryCore())

    def print_input_memory(self, tid: int = 0, limit: int = 10) -> None:
        """Print input memory for specific core."""
        if 0 <= tid < len(self.cores):
            self.cores[tid].print_input_memory(limit)

    def print_output_memory(self, tid: int = 0, limit: int = 10) -> None:
        """Print output memory for specific core."""
        if 0 <= tid < len(self.cores):
            self.cores[tid].print_output_memory(limit)

    def print_crossbar(self, tid: int = 0, limit: int = 10) -> None:
        """Print crossbar for specific core."""
        if 0 <= tid < len(self.cores):
            self.cores[tid].print_crossbar(limit)

    def aimc_process(self, tid: int = 0) -> None:
        """Perform MVM operation on specified core."""
        if 0 <= tid < len(self.cores):
            self.cores[tid].aimc_process()

    def aimc_queue(self, tid: int, val: int) -> None:
        """Queue values to specified core."""
        if 0 <= tid < len(self.cores):
            self.cores[tid].aimc_queue(val)

    def aimc_dequeue(self, tid: int = 0) -> int:
        """Dequeue values from specified core."""
        if 0 <= tid < len(self.cores):
            return self.cores[tid].aimc_dequeue()
        return 0

    def aimc_param_read(self, tid: int, x: int, y: int) -> int:
        """Read parameter from specified core."""
        if 0 <= tid < len(self.cores):
            return self.cores[tid].aimc_param_read(x, y)
        return 0

    def aimc_param_write(self, tid: int, x: int, y: int, val: int) -> None:
        """Write parameter to specified core."""
        if 0 <= tid < len(self.cores):
            self.cores[tid].aimc_param_write(x, y, val)


# Global AIMC instance for checker mode
aimc = AnalogComputationalMemory(8)


# Intrinsics Emulation Functions

def aimc_process(tid: int = 0) -> int:
    """
    CM Core Process (MVM)
    Instruction format: |____Opcode___|__rm__|_X|__ra__|__rn__|__rd__|
    Bits:               |31_________21|20__16|15|14__10|9____5|4____0|
    Binary layout:      |0000_0001_100|0_1000|_0|001_11|01_001|0_1010|
    Hex layout:         |__0____1____8|____8_|__|_1____|D____2|____A_|
    gem5 variables:     |_____________|_Op264|__|_Op364|_Op164|Dest64|
    
    Arguments: None.
    """
    aimc.aimc_process(tid)
    return 0


def aimc_queue(rm: int, tid: int = 0) -> int:
    """
    CM Core Input Memory Queue
    Instruction format: |____Opcode___|__rm__|_?|__ra__|__rn__|__rd__|
    Bits:               |31_________21|20__16|15|14__10|9____5|4____0|
    Binary layout:      |0010_0001_100|0_1000|_1|001_11|01_001|0_1010|
    Hex layout:         |__2____1____8|____8_|__|_9____|D____2|____A_|
    gem5 variables:     |_____________|_Op264|__|_Op364|_Op164|Dest64|
    
    Queueing arguments:
    -- rm = QUEUE_MAX input values packed as <val7, val6, ..., val0> for
           queueing.
    """
    aimc.aimc_queue(tid, rm)
    return 0


def aimc_dequeue(tid: int = 0) -> int:
    """
    CM Core Output Memory Dequeue
    Instruction format: |____Opcode___|__rm__|_?|__ra__|__rn__|__rd__|
    Bits:               |31_________21|20__16|15|14__10|9____5|4____0|
    Binary layout:      |0010_0001_100|0_1000|_0|001_11|01_001|0_1010|
    Hex layout:         |__2____1____8|____8_|__|_1____|D____2|____A_|
    gem5 variables:     |_____________|_Op264|__|_Op364|_Op164|Dest64|
    
    Queueing arguments:
    -- rd = QUEUE_MAX output values packed as <val7, val6, ..., val0>.
    """
    return aimc.aimc_dequeue(tid)


def aimc_param_read(rm: int, rn: int, ra: int, tid: int = 0) -> int:
    """
    CM Core Parameter Read
    Instruction format: |____Opcode___|__rm__|_?|__ra__|__rn__|__rd__|
    Bits:               |31_________21|20__16|15|14__10|9____5|4____0|
    Binary layout:      |0100_0001_100|0_1000|_1|001_11|01_001|0_1010|
    Hex layout:         |__4____1____8|____8_|__|_9____|D____2|____A_|
    gem5 variables:     |_____________|_Op264|__|_Op364|_Op164|Dest64|
    
    Queueing arguments:
    -- rd = Parameter value.
    -- rm = Parameter x index.
    -- rn = Parameter y index.
    """
    return aimc.aimc_param_read(tid, rm, rn)


def aimc_param_write(rm: int, rn: int, ra: int, tid: int = 0) -> int:
    """
    CM Core Parameter Write
    Instruction format: |____Opcode___|__rm__|_?|__ra__|__rn__|__rd__|
    Bits:               |31_________21|20__16|15|14__10|9____5|4____0|
    Binary layout:      |0100_0001_100|0_1000|_0|001_11|01_001|0_1010|
    Hex layout:         |__4____1____8|____8_|__|_1____|D____2|____A_|
    gem5 variables:     |_____________|_Op264|__|_Op364|_Op164|Dest64|
    
    Queueing arguments:
    -- rd = Success code.
    -- rm = Parameter x index.
    -- ra = Parameter value.
    -- rn = Parameter y index.
    """
    aimc.aimc_param_write(tid, rm, rn, ra)
    return 0
