#!/bin/bash

# Build without optimisations
gcc main-128.c -o mult_128_c
perf stat -r 10 -o analize_data_x64_c.txt -e user_time,instructions,cycles ./mult_128_c

# Build with max optimisations
gcc main-128.c -O3 -o mult_128_c_o3
perf stat -r 10 -o analize_data_x64_c_o3.txt -e user_time,instructions,cycles ./mult_128_c_o3
 
