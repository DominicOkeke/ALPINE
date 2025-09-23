/* Copyright EPFL 2022
 * Joshua Klein
 * 
 * Example single 1k*1k perceptron layer using AIMClib using random weights and
 * inputs.  An example of how to compile this example is included within
 * build_example.sh.  The GCC/G++ build command line determines if the AIMClib
 * checker (gem5 model emulation) is used or not.
 * Updated for C++17 compatibility and GCC 11 on Ubuntu 22.04.
 *
 */

#include "aimc.hh"
#include <iostream>
#include <memory>
#include <random>
#include <chrono>

int main(int argc, char* argv[])
{
    // C++17: Test bench parameters with constexpr
    constexpr int n_x = 1024; // MLP input/output dimensions.
    constexpr int T_x = 10;   // Number of inferences.

    // C++17: Use smart pointers and modern random number generation
    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_int_distribution<int8_t> dis(-128, 127);

    // C++17: Use smart pointers for automatic memory management
    auto input = std::make_unique<std::unique_ptr<int8_t[]>[]>(T_x);
    auto W1 = std::make_unique<int8_t[]>(n_x * n_x);
    auto output = std::make_unique<std::unique_ptr<int8_t[]>[]>(T_x);
    
    for (int i = 0; i < T_x; i++) {
        input[i] = std::make_unique<int8_t[]>(n_x);
        output[i] = std::make_unique<int8_t[]>(n_x);
        for (int j = 0; j < n_x; j++) {
            input[i][j] = dis(gen);
            output[i][j] = dis(gen);
        }
    }
    
    for (int i = 0; i < n_x * n_x; i++) {
        W1[i] = dis(gen);
    }

    // C++17: Map weights to AIMC tile using modern syntax
    mapMatrix(0, 0, n_x, n_x, W1.get());

    // C++17: Do inference with timing
    auto start_time = std::chrono::high_resolution_clock::now();
    
    for (int i = 0; i < T_x; i++) 
    {
        // Queue input for next inference in first layer.
        queueVector(n_x, input[i].get());
        
        // Do MVM.
        aimcProcess();
        
        // Dequeue output from AIMC tile MVM.
        dequeueVector(n_x, output[i].get());
    }
    
    auto end_time = std::chrono::high_resolution_clock::now();
    auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end_time - start_time);
    
    // C++17: Print results with modern I/O
    std::cout << "ALPINE AIMC Library Example - C++17 Version\n";
    std::cout << "==========================================\n";
    std::cout << "Matrix dimensions: " << n_x << "x" << n_x << "\n";
    std::cout << "Number of inferences: " << T_x << "\n";
    std::cout << "Total execution time: " << duration.count() << " microseconds\n";
    std::cout << "Average time per inference: " << duration.count() / T_x << " microseconds\n";
    
    // C++17: Smart pointers automatically clean up memory
    return 0;
}

