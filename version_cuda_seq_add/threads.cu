
#include <stdio.h>
#include "threads.h"


// Combinatorio n sobre 2
__host__ __device__ int nchoose2(int n) {
    return n*(n-1)/2;
}


// Combinatorio n sobre 3
__host__ __device__ int nchoose3(int n) {
    return n*(n-1)*(n-2)/6;
}


// Limite inferior de N1
__host__ __device__ int N1_LI(int M, int i) {
    int aux = 0;
    for (int k = 1; k <= (i-1); k++) {
        aux += nchoose2(M-k);
    }
    return aux;
}

// Límite superior de N1
__host__ __device__ int N1_LS(int M, int i) {
    int aux = -1;
    for (int k = 1; k <= i; k++) {
        aux += nchoose2(M-k);
    }
    return aux;
}

// Límite inferior de N2
__host__ __device__ int N2_LI(int M, int i, int j) {
    return N1_LI(M, i) + (j-i-1)*(M-j)+nchoose2(j-i);
}

// Límite superior de N2
__host__ __device__ int N2_LS(int M, int i, int j) {
    //j=j-(i-1);
    return N1_LI(M, i) + (j-i)*(M-j)+nchoose2(j-i)-1;
}

// Limite de N3
__host__ __device__ int N3_L(int M, int i, int j, int k) {
    return N2_LI(M, i, j) + k - j - 1; 
}


// Imprime límites
__host__ __device__ void print_Limites(int M) {
    printf("%3s %2s/%2s %2s/%2s %2s/%2s %5s %5s %5s %5s %5s\n", "n", "i", "ii", "j", "jj", "k", "kk", "N1_LI", "N1_LS", "N2_LI", "N2_LS", "N3_L");
    int n=0;
    for (int i = 1; i<=M-2; i++) {
        for (int j = i+1; j<=M-1; j++) {
            for (int k = j+1; k<=M; k++) {
                int ii, jj, kk;
                get_ijk(M, n, &ii, &jj, &kk); 
                printf("%3d %2d/%2d %2d/%2d %2d/%2d %5d %5d %5d %5d %5d\n", n++, i, ii, j, jj, k, kk, N1_LI(M,i), N1_LS(M,i), N2_LI(M,i,j), N2_LS(M,i,j), N3_L(M,i,j,k));
            }
        }
    }
}



// Obtiene ijk
__host__ __device__ void get_ijk(int M, int n, int* i, int* j, int* k) {
    for (*i = 1; *i <= M-2; (*i)++) {
        if (n <= N1_LS(M, *i)) {
            for (*j = *i+1; *j <= M-1; (*j)++) {
                if ( n <= N2_LS(M, *i, *j) ) {
                    for (*k= *j+1; *k <= M; (*k)++) {
                        if ( n == N3_L(M, *i, *j, *k) )
                            return;
                    }
                }           
            }
        }
    }
}


// Comprueba validez ijk
__host__ __device__ void check_get_ijk(int M) {
    printf("**************************\n");
    printf("%3s: %3s/%3s %3s/%3s %3s/%3s\n", "n", "i", "ii", "j", "jj", "k", "kk");
    int n = 0;
    for (int i = 1; i<=M-2; i++) {
        for (int j = i+1; j<=M-1; j++) {
            for (int k = j+1; k<=M; k++) {
                int ii, jj, kk;
                get_ijk(M, n, &ii, &jj, &kk);
                printf("%3d: %3d/%3d %3d/%3d %3d/%3d\n", n, i, ii, j, jj, k, kk);
                if (i!=ii || j!=jj || k!=kk) {
                    printf("ERROR en cálculo de índices\n");
                    return;
                }
                n++;
            }
        }
    }
    
    if ( n != nchoose3(M) ) {
        printf("ERROR en n.\n");
        return;
    }

    printf("Generación (i,j,k): OK   **************************\n");
}