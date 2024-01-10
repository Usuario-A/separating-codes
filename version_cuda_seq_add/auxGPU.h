
#ifndef __AUX_GPU_H__
#define __AUX_GPU_H__

#include "general.h"



#define CUDA_CALL(x) do { if((x)!=cudaSuccess) { \
    printf("Error %d at %s:%d\n",x, __FILE__,__LINE__);\
    return EXIT_FAILURE;}} while(0)



#define MAX_THREADS 1024

__global__ void vectorAdd2(const float *A, const float *B, float *C, int numElements);

__host__ void controlError(const char * comentario); 



#endif