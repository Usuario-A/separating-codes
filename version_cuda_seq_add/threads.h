
#ifndef __HILOS_H__
#define __HILOS_H__

__host__ __device__ int nchoose2(int n);
__host__ __device__ int nchoose3(int n);

__host__ __device__ int N1_LI(int M, int i);
__host__ __device__ int N1_LS(int M, int i);

__host__ __device__ int N2_LI(int M, int i, int j);
__host__ __device__ int N2_LS(int M, int i, int j);

__host__ __device__ int N3_L(int M, int i, int j, int k);

__host__ __device__ void print_Limites(int M);



__host__ __device__ void get_ijk(int M, int n, int* i, int* j, int* k);


__host__ __device__ void check_get_ijk(int M); 

#endif