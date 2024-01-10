
#ifndef __SUBCodis_H__
#define __SUBCodis_H__

#include "Words.h"
#include "Events.h"

#define MAX_CODE_SIZE 4096

typedef struct SubCode {
  int n;
  int N;
  int M;
  Word_t* p[MAX_CODE_SIZE];
} sub_Code_t;


__host__ __device__ sub_Code_t* add_Word(sub_Code_t* sc, Word_t* p);

__global__ void d_add_Word(sub_Code_t* sc, Word_t* p); 

__host__ __device__ void print_Sub_Code(sub_Code_t* sc);

__host__ __device__ int dd_is_Sub_Code_Separating( sub_Code_t* sc, Word_t* p);

__global__ void d_is_Sub_Code_Separating(sub_Code_t*  d_sc, Word_t* d_p, int* d_esSep );



__global__ void  is_Sub_Code_Separating_kernel_3x(sub_Code_t*  d_sc, Word_t* d_p, int* d_esSep);

__global__ void is_Sub_Code_Separating_kernel(sub_Code_t*  d_sc, Word_t* d_p, int* d_esSep); 

#endif
