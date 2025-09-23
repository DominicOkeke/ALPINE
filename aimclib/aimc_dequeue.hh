/* 
 * Copyright EPFL 2021
 * Joshua Klein
 * 
 * This file contains functions for dequeueing larger data structures.
 *
 * TODO: Add in activation functions for optimized dequeue utilization.
 *
 */

#ifndef __AIMC_DEQUEUE_HH__
#define __AIMC_DEQUEUE_HH__

#include <cstdint>
#include <algorithm>
#include <array>

// C++17: int8_t vector dequeueing into array with improved type safety
inline void dequeueVector(int size, int8_t* v, int tid = 0) noexcept
{
    if (!v || size <= 0) return;
    
#if defined (LOOSELY_COUPLED_MMIO)
    for (int i = 0; i < size; i++) {
        v[i] = static_cast<int8_t>(aimcDequeue(tid));
    }
#else // (LOOSELY_COUPLED_MMIO)
    uint32_t tmp = 0;

    for (int i = 0; i < size; i++) {
        if (i % 4 == 0) {
            tmp = aimcDequeue(tid);
        }

        v[i] = static_cast<int8_t>(tmp & 0xff);
        tmp >>= 8;
    }
#endif // (LOOSELY_COUPLED_MMIO)
}

// C++17: Vector dequeueing for higher precision, scaled according to max.
template <typename T>
inline void dequeueVector(int size, T max, T* v, int tid = 0) noexcept
{
    if (!v || size <= 0 || max == 0) return;
    
    constexpr T scale_factor = 127;
    
#if defined (LOOSELY_COUPLED_MMIO)
    for (int i = 0; i < size; i++) {
        v[i] = (static_cast<T>(aimcDequeue(tid)) / scale_factor) * max;
    }
#else // (LOOSELY_COUPLED_MMIO)
    uint32_t tmp = 0;

    for (int i = 0; i < size; i++) {
        if (i % 4 == 0) {
            tmp = aimcDequeue(tid);
        }

        v[i] = (static_cast<T>(tmp & 0xff) / scale_factor) * max;
        tmp >>= 8;
    }
#endif // (LOOSELY_COUPLED_MMIO)
}

#endif // __AIMC_DEQUEUE_HH__
