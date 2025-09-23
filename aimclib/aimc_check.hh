/* 
 * Copyright EPFL 2021
 * Joshua Klein
 * 
 * This file contains classes functions for which we can emulate and check
 * the code in the associated gem5 model.  This model reflects an updated
 * model optimized for queueing and dequeueing: we assume that the control unit
 * of the AIMC core has two internal counters that can be used for the
 * addressing of the input and output memories.
 *
 * The workflow of the core model is as follows:
 * - 1. Load your input vector into the input memory of the AIMC core model:
 * - - a. Scale your input values to 8-bit and apply a to make the values
 *        unsigned.
 * - - b. Write up to scaled inputs to register R, such that it is packed as
 *        <<input 3>, <input 2>, <input 1>, <input 0>> (note this example is
 *        for use with a 32-bit register).
 * - - c. Call the CM_QUEUE custom instruction so that it takes the values in
 *        R, and places them in the input memory.  The first time this
 *        instruction is called, the AIMC control unit's input memory counter
 *        is set to 0, and so this value will be incremeneted by 4 in order to
 *        mean that 4 values have been "queued" in the input memory.  The 4
 *        packed values will reside in the first four places of the AIMC core's
 *        input memory.
 * - - d. Call the CM_QUEUE custom instrution enough times so that the entire
 *        input vector resides in the input memory.
 * - 2. Perform the MVM in the AIMC CORE MODEL: Call the CM_PROCESS custom
 *      instruction once.  This will perform A * B = C where A is the matrix
 *      held in the AIMC core, B is the vector in the input memory, and C is
 *      the output vector placed in the output memory.  The CM_PROCESS custom
 *      also resets both the input and output memory control unit queueing
 *      counters as well as the input memory.
 * - 3. Read the output vector from the output memory of the AIMC core model:
 * - - a. Call the CM_DEQUEUE custom instruction to read from the output memory
 *        into register R.  Assuming a 32-bit register, R will contain 4 and
 *        packed unsigned 8-bit integers from the first 4 output memory cells.
 *        The output memory control unit dequeueing counter will also increment
 *        by 4.
 * - - b. Repeat the CM_DEQUEUE instruction call until the entire output memory
 *        vector is retrieved.  Note that the output values will need to be
 *        scaled back up from 8-bit.
 *
 */

#ifndef __AIMC_CHECK_HH__
#define __AIMC_CHECK_HH__

#include <iostream>
#include <vector>
#include <memory>
#include <algorithm>
#include <cstdint>
#include <array>

// C++17 features: using namespace std is discouraged, use specific namespaces
using std::cout;
using std::endl;
using std::vector;
using std::unique_ptr;
using std::make_unique;


//////////////////////////
// Core-Local AIMC Core //
//////////////////////////
struct AnalogComputationalMemoryCore {
    // C++17 constructor with member initializer list and smart pointers
    AnalogComputationalMemoryCore() : 
    crossbarHeight(4000),
    crossbarWidth(4000),
    crossbar(std::make_unique<int8_t[]>(crossbarWidth * crossbarHeight)),
    inputMemory(std::make_unique<int8_t[]>(crossbarHeight)),
    outputMemory(std::make_unique<int8_t[]>(crossbarWidth)),
    inputMemoryCounter(0),
    outputMemoryCounter(0),
    vectorization(4)
    {
        // C++17: Use std::fill for better performance and clarity
        std::fill(inputMemory.get(), inputMemory.get() + crossbarHeight, 0);
        std::fill(outputMemory.get(), outputMemory.get() + crossbarWidth, 0);
        std::fill(crossbar.get(), crossbar.get() + crossbarWidth * crossbarHeight, 0);
    }

    // C++17: Use constexpr for compile-time constants
    static constexpr int crossbarHeight = 4000;   // Height of input memory too.
    static constexpr int crossbarWidth = 4000;    // Width of output memory too.
    static constexpr int vectorization = 4;       // How many values do we queue/dequeue?
    
    // C++17: Use smart pointers for automatic memory management
    std::unique_ptr<int8_t[]> crossbar;          // Parameters crossbar.
    std::unique_ptr<int8_t[]> inputMemory;       // Input memory (pre-DAC).
    std::unique_ptr<int8_t[]> outputMemory;      // Output memory (post-ADC).
    
    int inputMemoryCounter{0};     // Index into input memory.
    int outputMemoryCounter{0};    // Index into output memory.
};


////////////////
// AIMC Cores //
////////////////
class AnalogComputationalMemory {
  public:
    // C++17: Use smart pointers for automatic memory management
    std::vector<std::unique_ptr<AnalogComputationalMemoryCore>> cores;

  public:
    // C++17: Use default member initializers and delegating constructors
    AnalogComputationalMemory() : AnalogComputationalMemory(1) {}

    explicit AnalogComputationalMemory(int numOfCores)
    {
        cores.reserve(numOfCores);  // C++17: Reserve space for better performance
        for (int i = 0; i < numOfCores; i++) {
            cores.push_back(std::make_unique<AnalogComputationalMemoryCore>());
        }
    }

    // C++17: Rule of Five - default destructor is sufficient with smart pointers
    ~AnalogComputationalMemory() = default;
    
    // C++17: Disable copy constructor and assignment operator
    AnalogComputationalMemory(const AnalogComputationalMemory&) = delete;
    AnalogComputationalMemory& operator=(const AnalogComputationalMemory&) = delete;
    
    // C++17: Enable move constructor and assignment operator
    AnalogComputationalMemory(AnalogComputationalMemory&&) = default;
    AnalogComputationalMemory& operator=(AnalogComputationalMemory&&) = default;

    // C++17: Helpers for debugging with const correctness and range-based loops
    void printInputMemory(int tid, int limit = 10) const
    {
        if (tid < 0 || tid >= static_cast<int>(cores.size())) return;
        
        cout << "AIMC Core " << tid << " Input Memory =\n";
        const auto& core = cores[tid];
        for (int i = 0; i < core->crossbarHeight && i < limit; i++) {
            if (((i % 10) == 0) && (i > 0)) {
                cout << endl;
            }
            cout << static_cast<int>(core->inputMemory[i]) << '\t';
        } 
        cout << endl;
    }

    void printOutputMemory(int tid, int limit = 10) const
    {
        if (tid < 0 || tid >= static_cast<int>(cores.size())) return;
        
        cout << "AIMC Core " << tid << " Output Memory =\n";
        const auto& core = cores[tid];
        for (int i = 0; i < core->crossbarWidth && i < limit; i++) {
            if (((i % 10) == 0) && (i > 0)) {
                cout << endl;
            }
            cout << static_cast<int>(core->outputMemory[i]) << '\t';
        } 
        cout << endl;
    }

    void printCrossbar(int tid, int limit = 10) const
    {
        if (tid < 0 || tid >= static_cast<int>(cores.size())) return;
        
        cout << "AIMC Core " << tid << " Crossbar =\n";
        const auto& core = cores[tid];
        for (int i = 0; i < core->crossbarWidth && i < limit; i++) {
            for (int j = 0; j < limit; j++) {
                cout << static_cast<int>(core->crossbar[i * core->crossbarWidth + j]) << '\t';
            }
            cout << endl;
        } 
        cout << endl;
    }

    // C++17: AIMC operations with bounds checking and const correctness
    void aimcProcess(int tid = 0)
    {
        if (tid < 0 || tid >= static_cast<int>(cores.size())) return;
        
        auto& core = cores[tid];
        constexpr int height = AnalogComputationalMemoryCore::crossbarHeight;
        constexpr int width = AnalogComputationalMemoryCore::crossbarWidth;

        for (int i = 0; i < width; i++) {
            double acc = 0.0;

            for (int j = 0; j < height; j++) {
                acc += static_cast<double>(core->inputMemory[j]) * 
                       static_cast<double>(core->crossbar[j * width + i]);
            }

            // C++17: Use std::clamp for better bounds checking
            constexpr int8_t min_val = -128;
            constexpr int8_t max_val = 127;
            core->outputMemory[i] = static_cast<int8_t>(std::clamp(acc, 
                static_cast<double>(min_val), static_cast<double>(max_val)));
        }

        // C++17: Use std::fill for better performance
        std::fill(core->inputMemory.get(), core->inputMemory.get() + height, 0);

        core->inputMemoryCounter = 0;
        core->outputMemoryCounter = 0;
    }

    // C++17: Queue function with bounds checking
    void aimcQueue(int tid, uint32_t val)
    {
        if (tid < 0 || tid >= static_cast<int>(cores.size())) return;
        
        auto& core = cores[tid];
        int idx = core->inputMemoryCounter;
        constexpr int length = AnalogComputationalMemoryCore::vectorization;

        if ((idx + length) < AnalogComputationalMemoryCore::crossbarHeight) {
            for (int i = 0; i < length; i++) {
                int8_t currVal = static_cast<int8_t>((val >> (8 * i)) & 0xff);
                core->inputMemory[idx + i] = currVal;
            }
        }

        core->inputMemoryCounter += length;
    }

    // C++17: Dequeue function with bounds checking
    uint32_t aimcDequeue(int tid)
    {
        if (tid < 0 || tid >= static_cast<int>(cores.size())) return 0;
        
        auto& core = cores[tid];
        uint32_t result = 0;
        int idx = core->outputMemoryCounter;
        constexpr int length = AnalogComputationalMemoryCore::vectorization;

        if ((idx + length) < AnalogComputationalMemoryCore::crossbarWidth) {
            for (int i = length - 1; i >= 0; i--) {
                result <<= 8;
                result |= 0xff & static_cast<uint8_t>(core->outputMemory[idx + i]);
            }
        }

        core->outputMemoryCounter += length;
        return result;
    }

    // C++17: Parameter read with bounds checking
    int8_t aimcParamRead(int tid, int x, int y) const
    {
        if (tid < 0 || tid >= static_cast<int>(cores.size())) return 0;
        
        const auto& core = cores[tid];
        constexpr int height = AnalogComputationalMemoryCore::crossbarHeight;
        constexpr int width = AnalogComputationalMemoryCore::crossbarWidth;
        int idx = (y * width) + x; // 1D index

        if (idx >= 0 && idx < width * height) {
            return core->crossbar[idx];
        }

        return 0;
    }

    // C++17: Parameter write with bounds checking
    void aimcParamWrite(int tid, int x, int y, int8_t val)
    {
        if (tid < 0 || tid >= static_cast<int>(cores.size())) return;
        
        auto& core = cores[tid];
        constexpr int height = AnalogComputationalMemoryCore::crossbarHeight;
        constexpr int width = AnalogComputationalMemoryCore::crossbarWidth;
        int idx = (y * width) + x; // 1D index

        if (idx >= 0 && idx < width * height) {
            core->crossbar[idx] = val;
        }
    }
};


// C++17: If we are compiling using the checker, instantiate one core and assume
// initial thread 0. Use inline variable for better C++17 compliance
inline AnalogComputationalMemory aimc{8};

//////////////////////////
// Intrinsics Emulation //
//////////////////////////

/* CM Core Process (MVM)
 * Instruction format: |____Opcode___|__rm__|_X|__ra__|__rn__|__rd__|
 * Bits:               |31_________21|20__16|15|14__10|9____5|4____0|
 * Binary layout:      |0000_0001_100|0_1000|_0|001_11|01_001|0_1010|
 * Hex layout:         |__0____1____8|____8_|__|_1____|D____2|____A_|
 * gem5 variables:     |_____________|_Op264|__|_Op364|_Op164|Dest64|
 *
 * Arguments: None.
 */
// C++17: Use constexpr and noexcept where appropriate
constexpr uint64_t aimcProcess(int tid = 0) noexcept
{
    aimc.aimcProcess(tid);
    return 0;
}

/* CM Core Input Memory Queue
 * Instruction format: |____Opcode___|__rm__|_?|__ra__|__rn__|__rd__|
 * Bits:               |31_________21|20__16|15|14__10|9____5|4____0|
 * Binary layout:      |0010_0001_100|0_1000|_1|001_11|01_001|0_1010|
 * Hex layout:         |__2____1____8|____8_|__|_9____|D____2|____A_|
 * gem5 variables:     |_____________|_Op264|__|_Op364|_Op164|Dest64|
 *
 * Queueing arguments:
 * -- rm = QUEUE_MAX input values packed as <val7, val6, ..., val0> for
 *         queueing.
 */
// C++17: Use constexpr and noexcept where appropriate
constexpr uint64_t aimcQueue(uint64_t rm, int tid = 0) noexcept
{
    aimc.aimcQueue(tid, rm);
    return 0;
}

/* CM Core Output Memory Dequeue
 * Instruction format: |____Opcode___|__rm__|_?|__ra__|__rn__|__rd__|
 * Bits:               |31_________21|20__16|15|14__10|9____5|4____0|
 * Binary layout:      |0010_0001_100|0_1000|_0|001_11|01_001|0_1010|
 * Hex layout:         |__2____1____8|____8_|__|_1____|D____2|____A_|
 * gem5 variables:     |_____________|_Op264|__|_Op364|_Op164|Dest64|
 *
 * Queueing arguments:
 * -- rd = QUEUE_MAX output values packed as <val7, val6, ..., val0>.
 */
// C++17: Use constexpr and noexcept where appropriate
constexpr uint64_t aimcDequeue(int tid = 0) noexcept
{
    return aimc.aimcDequeue(tid);
}

/* CM Core Parameter Read
 * Instruction format: |____Opcode___|__rm__|_?|__ra__|__rn__|__rd__|
 * Bits:               |31_________21|20__16|15|14__10|9____5|4____0|
 * Binary layout:      |0100_0001_100|0_1000|_1|001_11|01_001|0_1010|
 * Hex layout:         |__4____1____8|____8_|__|_9____|D____2|____A_|
 * gem5 variables:     |_____________|_Op264|__|_Op364|_Op164|Dest64|
 *
 * Queueing arguments:
 * -- rd = Parameter value.
 * -- rm = Parameter x index.
 * -- rn = Parameter y index.
 */
// C++17: Use constexpr and noexcept where appropriate
constexpr uint64_t aimcParamRead(uint64_t rm, uint64_t rn, uint64_t ra, int tid = 0) noexcept
{
    return aimc.aimcParamRead(tid, rm, rn);
}

/* CM Core Parameter Write
 * Instruction format: |____Opcode___|__rm__|_?|__ra__|__rn__|__rd__|
 * Bits:               |31_________21|20__16|15|14__10|9____5|4____0|
 * Binary layout:      |0100_0001_100|0_1000|_0|001_11|01_001|0_1010|
 * Hex layout:         |__4____1____8|____8_|__|_1____|D____2|____A_|
 * gem5 variables:     |_____________|_Op264|__|_Op364|_Op164|Dest64|
 *
 * Queueing arguments:
 * -- rd = Success code.
 * -- rm = Parameter x index.
 * -- ra = Parameter value.
 * -- rn = Parameter y index.
 */
// C++17: Use constexpr and noexcept where appropriate
constexpr uint64_t aimcParamWrite(uint64_t rm, uint64_t rn, uint64_t ra, int tid = 0) noexcept
{
    aimc.aimcParamWrite(tid, rm, rn, ra);
    return 0;
}

#endif // __AIMC_CHECK_HH__
