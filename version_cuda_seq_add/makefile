#EXEC ?= @echo "[@]"

default: all

g:
	gdb ./test	

exe:
	./test	

%.o:%.cu
	$(EXEC) nvcc -dc -I./  -c $<

all:  Words.o events.o subCodes.o auxGPU.o threads.o results.o  main.o
	$(EXEC) nvcc -I./ -o test $+  -lm

clean:
	rm -rf *.o


		