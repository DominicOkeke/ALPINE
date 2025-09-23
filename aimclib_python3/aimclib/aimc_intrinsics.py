#!/usr/bin/env python3
"""
Copyright EPFL 2021
Joshua Klein

This file contains wrappers for in-line assembly access to the AIMC core via
custom instructions. The custom instruction definitions are included and
match those found in the gem5 model.

Note: This Python version provides a simulation interface rather than actual
assembly instructions. For real hardware, you would need to implement
platform-specific assembly calls or use a C extension.
"""

import ctypes
import os
import platform
from typing import Optional


class AIMCIntrinsics:
    """Wrapper class for AIMC intrinsics with platform-specific implementations."""
    
    def __init__(self):
        self._lib = None
        self._load_library()
    
    def _load_library(self):
        """Load platform-specific library if available."""
        try:
            # Try to load a compiled C library with actual assembly implementations
            if platform.system() == "Linux":
                lib_path = os.path.join(os.path.dirname(__file__), "libaimc_intrinsics.so")
                if os.path.exists(lib_path):
                    self._lib = ctypes.CDLL(lib_path)
        except Exception:
            # Fall back to simulation mode
            self._lib = None
    
    def aimc_process(self, tid: int = 0) -> None:
        """
        CM Core Process (MVM)
        Instruction format: |____Opcode___|__rm__|_X|__ra__|__rn__|__rd__|
        Bits:               |31_________21|20__16|15|14__10|9____5|4____0|
        Binary layout:      |0000_0001_000|0_0000|_0|000_00|00_000|0_0000|
        Hex layout:         |__0____1____0|____0_|__|_0____|0____0|____0_|
        gem5 variables:     |_____________|_Op264|__|_Op364|_Op164|Dest64|
        
        Arguments: None.
        """
        if self._lib:
            # Use actual assembly implementation
            self._lib.aimc_process(tid)
        else:
            # Fall back to simulation mode
            print(f"SIMULATION: aimc_process(tid={tid})")
    
    def aimc_queue(self, rm: int, tid: int = 0) -> None:
        """
        CM Core Input Memory Queue
        Instruction format: |____Opcode___|__rm__|_?|__ra__|__rn__|__rd__|
        Bits:               |31_________21|20__16|15|14__10|9____5|4____0|
        Binary layout:      |0010_0001_000|0_1000|_1|000_00|00_000|0_0000|
        Hex layout:         |__2____1____0|____8_|__|_8____|0____0|____0_|
        gem5 variables:     |_____________|_Op264|__|_Op364|_Op164|Dest64|
        
        Queueing arguments:
        -- rm = QUEUE_MAX input values packed as <val7, val6, ..., val0> for
               queueing.
        """
        if self._lib:
            # Use actual assembly implementation
            self._lib.aimc_queue(rm, tid)
        else:
            # Fall back to simulation mode
            print(f"SIMULATION: aimc_queue(rm={rm}, tid={tid})")
    
    def aimc_dequeue(self, tid: int = 0) -> int:
        """
        CM Core Output Memory Dequeue
        Instruction format: |____Opcode___|__rm__|_?|__ra__|__rn__|__rd__|
        Bits:               |31_________21|20__16|15|14__10|9____5|4____0|
        Binary layout:      |0010_0001_000|0_0000|_0|000_00|00_000|0_1010|
        Hex layout:         |__2____1____0|____0_|__|_0____|0____0|____A_|
        gem5 variables:     |_____________|_Op264|__|_Op364|_Op164|Dest64|
        
        Queueing arguments:
        -- rd = QUEUE_MAX output values packed as <val7, val6, ..., val0>.
        """
        if self._lib:
            # Use actual assembly implementation
            return self._lib.aimc_dequeue(tid)
        else:
            # Fall back to simulation mode
            print(f"SIMULATION: aimc_dequeue(tid={tid})")
            return 0
    
    def aimc_param_read(self, rm: int, rn: int, ra: int, tid: int = 0) -> int:
        """
        CM Core Parameter Read
        Instruction format: |____Opcode___|__rm__|_?|__ra__|__rn__|__rd__|
        Bits:               |31_________21|20__16|15|14__10|9____5|4____0|
        Binary layout:      |0100_0001_000|0_1000|_1|000_00|01_001|0_1010|
        Hex layout:         |__4____1____0|____8_|__|_8____|1____2|____A_|
        gem5 variables:     |_____________|_Op264|__|_Op364|_Op164|Dest64|
        
        Queueing arguments:
        -- rd = Parameter value.
        -- rm = Parameter x index.
        -- rn = Parameter y index.
        """
        if self._lib:
            # Use actual assembly implementation
            return self._lib.aimc_param_read(rm, rn, ra, tid)
        else:
            # Fall back to simulation mode
            print(f"SIMULATION: aimc_param_read(rm={rm}, rn={rn}, ra={ra}, tid={tid})")
            return 0
    
    def aimc_param_write(self, rm: int, rn: int, ra: int, tid: int = 0) -> int:
        """
        CM Core Parameter Write
        Instruction format: |____Opcode___|__rm__|_?|__ra__|__rn__|__rd__|
        Bits:               |31_________21|20__16|15|14__10|9____5|4____0|
        Binary layout:      |0100_0001_000|0_1000|_0|001_11|01_001|0_1010|
        Hex layout:         |__4____1____0|____8_|__|_1____|D____2|____A_|
        gem5 variables:     |_____________|_Op264|__|_Op364|_Op164|Dest64|
        
        Queueing arguments:
        -- rd = Success code.
        -- rm = Parameter x index.
        -- ra = Parameter value.
        -- rn = Parameter y index.
        """
        if self._lib:
            # Use actual assembly implementation
            return self._lib.aimc_param_write(rm, rn, ra, tid)
        else:
            # Fall back to simulation mode
            print(f"SIMULATION: aimc_param_write(rm={rm}, rn={rn}, ra={ra}, tid={tid})")
            return 0


# Global instance for easy access
_aimc_intrinsics = AIMCIntrinsics()


# Convenience functions that match the C++ interface
def aimc_process(tid: int = 0) -> None:
    """CM Core Process (MVM) - convenience function."""
    _aimc_intrinsics.aimc_process(tid)


def aimc_queue(rm: int, tid: int = 0) -> None:
    """CM Core Input Memory Queue - convenience function."""
    _aimc_intrinsics.aimc_queue(rm, tid)


def aimc_dequeue(tid: int = 0) -> int:
    """CM Core Output Memory Dequeue - convenience function."""
    return _aimc_intrinsics.aimc_dequeue(tid)


def aimc_param_read(rm: int, rn: int, ra: int, tid: int = 0) -> int:
    """CM Core Parameter Read - convenience function."""
    return _aimc_intrinsics.aimc_param_read(rm, rn, ra, tid)


def aimc_param_write(rm: int, rn: int, ra: int, tid: int = 0) -> int:
    """CM Core Parameter Write - convenience function."""
    return _aimc_intrinsics.aimc_param_write(rm, rn, ra, tid)
