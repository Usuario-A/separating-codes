#include <stdio.h>
#include "results.h"


// Guarda en un fichero el subcódigo
void save_Code(sub_Code_t* sc, const char* fichero){
    FILE *f = fopen(fichero, "w");
    fprintf(f, "Code=[\n");
    for (int i = 0; i < sc->M; i++ ) {
        TYPE_BIN cBin[sc->n];
        cDec2cBin(sc->N, sc->p[i]->v, sc->n, cBin);
        for (int j = 0; j < sc->n; j++) {
            fprintf(f, "%d ", cBin[j]);
        }
        fprintf(f, "\n");
    }
    fprintf(f, "];");
    fclose(f);
}


// guarda en un fichero un vector de enteros
void printf_Vector_Int(FILE* f, const char* nombre, int np, int* v) {
    fprintf(f, "%s = [\n", nombre);
    for (int i = 0; i<np; i++) {
        fprintf(f, "%d ", v[i]);
    }
    fprintf(f, "];\n");
}

// guarda en un fichero un vector de floats
void printf_Vector_Float(FILE* f, const char* nombre, int np, float* v) {
    fprintf(f, "%s = [\n", nombre);
    for (int i = 0; i<np; i++) {
        fprintf(f, "%f ", v[i]);
    }
    fprintf(f, "];\n");
}


// guarda en un fichero los results de la simulación
void guardar_results(const char* fichero, struct parametros* param, struct info* datos, int np, int cont){
    FILE *f = fopen(fichero, "w");
    fprintf(f, "semilla = %d;\n", param->seed);
    fprintf(f, "nombre_GPU = '%s';\n", param->name);
    fprintf(f, "multiProcessorCount = %d\n", param->multiProcessorCount);
    fprintf(f, "maxThreadsPerMultiProcessor = %d\n", param->maxThreadsPerMultiProcessor);
    fprintf(f, "maxThreadsPerBlock = %d\n", param->maxThreadsPerBlock);
    fprintf(f, "maxTheadsDim = [%d, %d, %d]\n", param->maxThreadsDim[0], param->maxThreadsDim[1], param->maxThreadsDim[2]);
    fprintf(f, "n = %d\n", param->n);
    fprintf(f, "M = %d\n", param->M);
    printf_Vector_Int(f,   "n_eventos",        np,   datos->n_Events);
    printf_Vector_Int(f,   "blocks",          np,   datos->blocks);
    printf_Vector_Int(f,   "threads",          np,   datos->threads);
    printf_Vector_Int(f,   "Word",          np,   datos->Word);
    printf_Vector_Int(f,   "Word_Code",   cont, datos->blocks);
    printf_Vector_Float(f, "t_pre_kernel",     np,   datos->t_pre_kernel);
    printf_Vector_Float(f, "t_kernel",         np,   datos->t_kernel);
    printf_Vector_Float(f, "t_post_kernel",    np,   datos->t_post_kernel);
    printf_Vector_Float(f, "t_Word_Code", cont, datos->t_Word_Code);
    printf_Vector_Float(f, "t_Word",        np,   datos->t_Word);
    printf_Vector_Float(f, "t_iteracion",      np,   datos->t_iteracion);
    fclose(f);
}







