/* 
 * Copyright EPFL 2021
 * Joshua Klein
 * 
 * This file contains functions for mapping and tiling matrices to the AIMC
 * core using parameter write intrinsics.
 *
 */

#ifndef __AIMC_TILE_HH__
#define __AIMC_TILE_HH__

#include <cstdint>
#include <algorithm>
#include <array>

/* C++17: Map int8_t matrix to AIMC core, where the top left corner (0, 0) of the
 * matrix starts at (aimc_x, aimc_y) within the core.
 * 
 * TODO/NOTE: There are no bounds check!
 */
inline void mapMatrix(int aimc_x, int aimc_y, int height, int width, const int8_t* const* m) noexcept
{
    if (!m || height <= 0 || width <= 0) return;
    
    for (int i = 0; i < width; i++) {
        for (int j = 0; j < height; j++) {
            if (m[j]) {
                aimcParamWrite(i + aimc_x, j + aimc_y, m[j][i]);
            }
        }
    }
}

/* C++17: Map T matrix to AIMC core, where the top left corner (0, 0) of the
 * matrix starts at (aimc_x, aimc_y) within the core.  The values are scaled
 * to int8_t according to the maximum.
 * 
 * TODO/NOTE: There are no bounds check!
 */
template <typename T>
inline void mapMatrix(int aimc_x, int aimc_y, int height, int width, T max, const T* const* m) noexcept
{
    if (!m || height <= 0 || width <= 0 || max == 0) return;
    
    constexpr T scale_factor = 127;
    
    for (int i = 0; i < width; i++) {
        for (int j = 0; j < height; j++) {
            if (m[j]) {
                auto scaled_val = static_cast<int8_t>((m[j][i] / max) * scale_factor);
                aimcParamWrite(i + aimc_x, j + aimc_y, scaled_val);
            }
        }
    }
}

/* C++17: Map int8_t flattened matrix to AIMC core, where the top left corner (0, 0)
 * of the matrix starts at (aimc_x, aimc_y) within the core.
 * 
 * TODO/NOTE: There are no bounds check!
 */
inline void mapMatrix(int aimc_x, int aimc_y, int height, int width, const int8_t* m) noexcept
{
    if (!m || height <= 0 || width <= 0) return;
    
    for (int i = 0; i < width; i++) {
        for (int j = 0; j < height; j++) {
            aimcParamWrite(i + aimc_x, j + aimc_y, m[i * width + j]);
        }
    }
}

/* C++17: Map T flattened matrix to AIMC core, where the top left corner (0, 0) of the
 * matrix starts at (aimc_x, aimc_y) within the core.  The values are scaled
 * to int8_t according to the maximum.
 * 
 * TODO/NOTE: There are no bounds check!
 */
template <typename T>
inline void mapMatrix(int aimc_x, int aimc_y, int height, int width, T max, const T* m) noexcept
{
    if (!m || height <= 0 || width <= 0 || max == 0) return;
    
    constexpr T scale_factor = 127;
    
    for (int i = 0; i < width; i++) {
        for (int j = 0; j < height; j++) {
            auto scaled_val = static_cast<int8_t>((m[i * width + j] / max) * scale_factor);
            aimcParamWrite(i + aimc_x, j + aimc_y, scaled_val);
        }
    }
}

#endif // __AIMC_TILE_HH__