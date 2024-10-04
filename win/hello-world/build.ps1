nasm -f win64 main.asm -o main.o
link main.o kernel32.lib /entry:_main /subsystem:console /out:hello_world.exe
