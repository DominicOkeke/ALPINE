#!/usr/bin/env python3
"""
Copyright EPFL 2022
Joshua Klein

Example single 1k*1k perceptron layer using AIMClib using random weights and
inputs. An example of how to run this example is included within
build_example.sh. The Python version provides both simulation and hardware modes.
"""

import numpy as np
import random
import sys
import os

# Add the current directory to the Python path
sys.path.insert(0, os.path.dirname(__file__))

from aimc import (
    AnalogComputationalMemory,
    map_matrix,
    queue_vector,
    dequeue_vector,
    aimc_process
)


def main():
    """Main function demonstrating AIMC library usage."""
    # Test bench parameters
    n_x = 1024  # MLP input/output dimensions
    T_x = 10    # Number of inferences
    
    print("ALPINE AIMC Library Example")
    print("=" * 40)
    print(f"Matrix dimensions: {n_x}x{n_x}")
    print(f"Number of inferences: {T_x}")
    print()
    
    # Set up and initialize vectors/matrices
    print("Initializing data...")
    input_data = []
    W1 = np.random.randint(-128, 127, size=(n_x, n_x), dtype=np.int8)
    output_data = []
    
    for i in range(T_x):
        input_vec = np.random.randint(-128, 127, size=n_x, dtype=np.int8)
        output_vec = np.zeros(n_x, dtype=np.int8)
        input_data.append(input_vec)
        output_data.append(output_vec)
    
    print(f"Generated {T_x} input vectors and weight matrix")
    print(f"Weight matrix shape: {W1.shape}")
    print(f"Weight matrix range: [{W1.min()}, {W1.max()}]")
    print()
    
    # Initialize AIMC system
    print("Initializing AIMC system...")
    aimc = AnalogComputationalMemory(1)  # Single core for this example
    
    # Map weights to AIMC tile
    print("Mapping weights to AIMC tile...")
    map_matrix(0, 0, W1)
    print("Weight mapping completed")
    print()
    
    # Do inference
    print("Starting inference...")
    for i in range(T_x):
        print(f"Inference {i+1}/{T_x}...")
        
        # Queue input for next inference in first layer
        queue_vector(n_x, input_data[i])
        
        # Do MVM
        aimc_process()
        
        # Dequeue output from AIMC tile MVM
        dequeue_vector(n_x, output_data[i])
        
        # Print some statistics for the first few inferences
        if i < 3:
            print(f"  Input range: [{input_data[i].min()}, {input_data[i].max()}]")
            print(f"  Output range: [{output_data[i].min()}, {output_data[i].max()}]")
            print(f"  Output mean: {output_data[i].mean():.2f}")
    
    print("Inference completed!")
    print()
    
    # Print summary statistics
    print("Summary Statistics:")
    print("-" * 20)
    all_outputs = np.concatenate(output_data)
    print(f"Total outputs generated: {len(all_outputs)}")
    print(f"Output value range: [{all_outputs.min()}, {all_outputs.max()}]")
    print(f"Output mean: {all_outputs.mean():.2f}")
    print(f"Output std: {all_outputs.std():.2f}")
    
    # Verify against expected computation (for small subset)
    print("\nVerification (first inference, first 10 elements):")
    print("-" * 50)
    expected = np.dot(input_data[0], W1)
    expected = np.clip(expected, -128, 127).astype(np.int8)
    
    print("Expected (numpy):", expected[:10])
    print("Actual (AIMC):  ", output_data[0][:10])
    print("Match:          ", np.array_equal(expected[:10], output_data[0][:10]))
    
    print("\nExample completed successfully!")


if __name__ == "__main__":
    main()
