# Content

The code in this folder is a CUDA implementation of the sequential addition algorithm for obtaining 
**binary 2-separating codes**. 

It has been developed and tested in a computer with an Intel 
Xeon E5-2698 CPU with 512 GB and a Nvidia Tesla P-100 GPU.

The desired parameters of the code (word length n, number of words M) are set in the code,
in lines 56 and 61 of the file "main.cu". 

In order to obtain the code,  the software must be compiled 
using the `makefile`, and run the executable command `test`. 

If the algorithm ends successfully,
the obtained code is returned as an `M-file` for use in Matlab (although it can be read easily as an ASCII file).

# How to use it

## Compilation

```bash
make all
```

## Execution

```bash
make exe
```
