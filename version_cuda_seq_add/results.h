#ifndef __results_H__
#define __results_H__

#include "general.h"
#include "subCodes.h"

struct parametros {
    unsigned int seed; 
    char name[64];
    int multiProcessorCount;
    int maxThreadsPerMultiProcessor;
    int maxThreadsPerBlock;
    int maxThreadsDim[3];
    int n;
    int M;
};

#define MAX_RES 100000
struct info {
    int n_Events[MAX_RES];
    int blocks[MAX_RES];
    int threads[MAX_RES];
    int Word[MAX_RES];
    int Word_Code[MAX_RES];
    float t_pre_kernel[MAX_RES];
    float t_kernel[MAX_RES];
    float t_post_kernel[MAX_RES];
    float t_Word_Code[MAX_RES];
    float t_Word[MAX_RES];
    float t_iteracion[MAX_RES];
}; 

void save_Code(sub_Code_t* sc, const char* fichero);

void guardar_results(const char* fichero, struct parametros* param, struct info* datos, int np, int cont);

#endif