#include <stdio.h>
#include "auxGPU.h"


/* Control del último error CUDA */
__host__ void controlError(const char * comentario) {
    cudaError_t err = cudaGetLastError();
    if (err != cudaSuccess){
        fprintf(stderr, "Fail in %s, (error: %s)!\n", comentario, cudaGetErrorString(err));
        exit(EXIT_FAILURE);
    }
}    




























