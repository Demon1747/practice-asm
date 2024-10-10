#!/bin/bash

# Build without optimisations
gcc ../main-128.c arm64_mul128.s -o arm64_mult_128 -static
perf stat -r 10 -e task-clock,instructions,cycles -o analyze_data_arm64.txt ./arm64_mult_128

# Build with optimisations
gcc ../main-128.c arm64_mul128.s -o arm64_mult_128_o3 -static -O3
perf stat -r 10 -e task-clock,instructions,cycles -o analyze_data_arm64_o3.txt ./arm64_mult_128_o3

