#!/bin/bash

nasm -f elf64 main.asm -o main.o
ld -o hello_world main.o
