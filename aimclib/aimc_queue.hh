/* 
 * Copyright EPFL 2021
 * Joshua Klein
 * 
 * This file contains functions for queueing larger data structures.
 *
 */

#ifndef __AIMC_QUEUE_HH__
#define __AIMC_QUEUE_HH__

#include <cstdint>
#include <algorithm>
#include <array>

// C++17: int8_t vector queueing with improved type safety
inline void queueVector(int size, const int8_t* v, int tid = 0) noexcept
{
    if (!v || size <= 0) return;
    
#if defined (LOOSELY_COUPLED_MMIO)
    for (int i = 0; i < size; i++) {
        aimcQueue(static_cast<uint64_t>(v[i]));
    }
#else // (LOOSELY_COUPLED_MMIO)
    uint32_t tmp = 0;

    // Pack 4 int8 values into tmp, and queue into AIMC input memory.
    for (int i = 0; i < size; i++) {
        if ((i % 4 == 0) && i > 0) {
            aimcQueue(tmp, tid);
            tmp = 0;
        }

        tmp |= (static_cast<uint8_t>(v[i]) & 0xff) << (8 * (i % 4));
    }

    // Queue the leftover values, in case |v| % 4 != 0.
    aimcQueue(tmp, tid);
#endif // (LOOSELY_COUPLED_MMIO)
}

// C++17: Vector queueing for higher precision, scaled according to max.
template <typename T>
inline void queueVector(int size, T max, const T* v, int tid = 0) noexcept
{
    if (!v || size <= 0 || max == 0) return;
    
    constexpr T scale_factor = 127;
    
#if defined (LOOSELY_COUPLED_MMIO)
    for (int i = 0; i < size; i++) {
        auto scaled_val = static_cast<int8_t>((v[i] / max) * scale_factor);
        aimcQueue(static_cast<uint64_t>(scaled_val));
    }
#else // (LOOSELY_COUPLED_MMIO)
    uint32_t tmp = 0;

    // Pack 4 int8 values into tmp, and queue into AIMC input memory.
    for (int i = 0; i < size; i++) {
        if ((i % 4 == 0) && i > 0) {
            aimcQueue(tmp, tid);
            tmp = 0;
        }

        auto scaled_val = static_cast<int8_t>((v[i] / max) * scale_factor);
        tmp |= (static_cast<uint8_t>(scaled_val) & 0xff) << (8 * (i % 4));
    }

    // Queue the leftover values, in case |v| % 4 != 0.
    aimcQueue(tmp, tid);
#endif // (LOOSELY_COUPLED_MMIO)
}

#endif // __AIMC_QUEUE_HH__
