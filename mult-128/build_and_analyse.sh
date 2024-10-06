#!/bin/bash

# Build without optimisations
gcc main-128.c -o mult_128_c
perf stat -r 5 -e user_time,instructions,cycles ./mult_128_c

# Build with max optimisations
gcc main-128.c -O3 -o mult_128_c_O3
perf stat -r 5 -e user_time,instructions,cycles ./mult_128_c_O3 
