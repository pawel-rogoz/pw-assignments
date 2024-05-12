CC=gcc
ASMBIN=nasm

all : asm cc link
asm : 
	$(ASMBIN) -o code.o -f elf -g -l code.lst code.asm
cc :
	$(CC) -m32 -c -g -O0 main.c
link :
	$(CC) -m32 -g -o mst main.o code.o

clean :
	rm *.o
	rm mst	
	rm code.lst
