#!/bin/bash

# Build without optimisations
nasm -f elf64 x64_mul128.asm -o x64_mul128.o
gcc ../main-128.c x64_mul128.o -o x64_mult_128
perf stat -r 10 -e user_time,instructions,cycles ./x64_mult_128

# Build with optimisations
gcc ../main-128.c x64_mul128.o -O3 -o x64_mult_128_o3
perf stat -r 10 -e user_time,instructions,cycles ./x64_mult_128_o3

