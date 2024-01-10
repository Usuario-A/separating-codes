

#include <stdio.h>
#include <string.h>
#include "auxGPU.h"
#include "Events.h"
#include "threads.h"
#include "subCodes.h"



// Añade Word al subcódigo
__host__ __device__ sub_Code_t* add_Word(sub_Code_t* sc, Word_t* p) {
  sc->p[sc->M] = p;
  sc->M++;
  return sc;
}

// Añade Word al subcódigo
__global__ void d_add_Word(sub_Code_t* sc, Word_t* p) {
  sc->p[sc->M] = p;
  sc->M++;
}


// Imprime en pantalla el subcódigo
__host__ __device__ void print_Sub_Code(sub_Code_t* sc) {
    for (int i = 0; i < sc->M; i++ ) {
        printf("%4d: ", i);
        printWordBin((Word_t*)(sc->p[i]));
    }
}


// Retorna si el subcódigo es Separating o no
__host__ __device__ int dd_is_Sub_Code_Separating( sub_Code_t* sc, Word_t* p) {
    int block, pos;
    int n_Events =0;
    int cont = 1;
    for (int i = 1; i <= sc->M-2; i++) {
        for (int j = i+1; j<= sc->M-1; j++) {
            for (int k = j+1; k<=sc->M; k++) {

                if (DEPUR>DEPUR_2) printf("(%d,%d,%d,p)\n", i-1, j-1, k-1);
                Event_t* ev = new_Event(sc->p[i-1], sc->p[j-1], sc->p[k-1], p);
                n_Events++;
                if ( is_Event_Separating(ev, &block, &pos) ) {
                    if (DEPUR>DEPUR_3) printf("Event i-j-k Separating. block: %d, pos: %d\n", block, primer_Uno(pos));
                } else {
                    if (DEPUR>DEPUR_3) printf("Event i-j-k no Separating");
                    return FALSE; 
                }
                del_Event(ev);

                if (DEPUR>DEPUR_2) printf("(%d,%d,%d,p)\n", i-1, k-1, j-1);
                ev = new_Event(sc->p[i-1], sc->p[k-1], sc->p[j-1], p);
                n_Events++;
                if ( is_Event_Separating(ev, &block, &pos) ) {
                    if (DEPUR>DEPUR_3) printf("Event i-k-j Separating. block: %d, pos: %d\n", block, primer_Uno(pos));
                } else {
                    if (DEPUR>DEPUR_3) printf("Event i-k-j no Separating");
                    return FALSE; 
                }
                del_Event(ev);

                if (DEPUR>DEPUR_2) printf("(%d,%d,%d,p)\n", j-1, k-1, i-1);
                ev = new_Event(sc->p[j-1], sc->p[k-1], sc->p[i-1], p);
                n_Events++;
                if ( is_Event_Separating(ev, &block, &pos) ) {
                    if (DEPUR>DEPUR_3) printf("Event j-k-i Separating. block: %d, pos: %d\n", block, primer_Uno(pos));
                } else {
                    if (DEPUR>DEPUR_3) printf("Event j-k-i no Separating");
                    return FALSE; 
                }
                del_Event(ev);

if (DEPUR>DEPUR_1) { printf("%3d/%3d: | ", cont-1, (cont-1)*3); cont++; }
if (DEPUR>DEPUR_1) { printf("(%d,%d,%d,p) ", i, j, k);}
if (DEPUR>DEPUR_1) { printf("(%d,%d,%d,p) ", i, k, j);}
if (DEPUR>DEPUR_1) { printf("(%d,%d,%d,p)      ", j, k, i);}

if (DEPUR>DEPUR_1) { printf("(%d,%d,%d,p) ", i-1, j-1, k-1);}
if (DEPUR>DEPUR_1) { printf("(%d,%d,%d,p) ", i-1, k-1, j-1);}
if (DEPUR>DEPUR_1) { printf("(%d,%d,%d,p)\n", j-1, k-1, i-1);}

            }
               
        }
    }

    int M = sc->M;
    int n_Events_teo = M*(M-1)*(M-2)/2;
    if (DEPUR>DEPUR_1) printf("n_Events: %d; teóricos: %d\n", n_Events, n_Events_teo);
    return TRUE;
}



// Retorna si el subcódigo es Separating o no
__global__ void d_is_Sub_Code_Separating(sub_Code_t*  d_sc, Word_t* d_p, int* d_esSep ) {
    printf("d_sc->M: %d\n", d_sc->M);
    printf("d_p->n: %d\n", d_p->n);
    printf("d_p->N: %d\n", d_p->N);
    //*d_esSep = 27;
    *d_esSep = dd_is_Sub_Code_Separating( d_sc, d_p);
    //*d_esSep = 27;

    if ( *d_esSep ) {
            add_Word(d_sc, d_p);
            printf("(GPU)M: %d\n", d_sc->M);
            
        } else {
            printf("(GPU)candidato no era Separating\n");
        }

}





__global__ void is_Sub_Code_Separating_kernel_old(sub_Code_t*  d_sc, Word_t* d_p, int* d_esSep) {
    int thread_n = blockDim.x * blockIdx.x + threadIdx.x;
    int M = d_sc->M;
    int i, j, k;

    int threads_totales = nchoose3(M);

    extern __shared__ int sep[];

    //__shared__ int sep[1024];

    int block, pos;
    int n_Events =0;

    get_ijk(M, thread_n, &i, &j, &k);
    printf("M: %2d, thread: %2d, i=%2d, j=%2d, k=%2d\n", M, thread_n, i, j, k);

    *d_esSep = TRUE;

    if (DEPUR>DEPUR_2) printf("(%d,%d,%d,p)\n", i-1, j-1, k-1);
    Event_t* ev = new_Event(d_sc->p[i-1], d_sc->p[j-1], d_sc->p[k-1], d_p);
    n_Events++;
    if ( is_Event_Separating(ev, &block, &pos) ) {
        if (DEPUR>DEPUR_3) printf("Event i-j-k Separating. block: %d, pos: %d\n", block, primer_Uno(pos));
    } else {
        if (DEPUR>DEPUR_3) printf("Event i-j-k no Separating");
        sep[thread_n]=FALSE;
        printf("ABORT");
        del_Event(ev);
        goto final;
    }
    del_Event(ev);

    if (DEPUR>DEPUR_2) printf("(%d,%d,%d,p)\n", i-1, k-1, j-1);
    ev = new_Event(d_sc->p[i-1], d_sc->p[k-1], d_sc->p[j-1], d_p);
    n_Events++;
    if ( is_Event_Separating(ev, &block, &pos) ) {
        if (DEPUR>DEPUR_3) printf("Event i-k-j Separating. block: %d, pos: %d\n", block, primer_Uno(pos));
    } else {
        if (DEPUR>DEPUR_3) printf("Event i-k-j no Separating");
        sep[thread_n]=FALSE;
        printf("ABORT");
        del_Event(ev);
        goto final;
    }
    del_Event(ev);

    if (DEPUR>DEPUR_2) printf("(%d,%d,%d,p)\n", j-1, k-1, i-1);
    ev = new_Event(d_sc->p[j-1], d_sc->p[k-1], d_sc->p[i-1], d_p);
    n_Events++;
    if ( is_Event_Separating(ev, &block, &pos) ) {
        if (DEPUR>DEPUR_3) printf("Event j-k-i Separating. block: %d, pos: %d\n", block, primer_Uno(pos));
    } else {
        if (DEPUR>DEPUR_3) printf("Event j-k-i no Separating");
        sep[thread_n]=FALSE;
        printf("ABORT");
        del_Event(ev);
        goto final;
    }
    del_Event(ev);
   
    
    sep[thread_n] = TRUE;
    final: __syncthreads();




    if (thread_n==0) {
        for (int i=0; i<threads_totales; i++) {
            if (!sep[i]) {
                *d_esSep = FALSE;
                printf("(GPU) No es Separating!!!");
                return;
            }
        }
        *d_esSep = TRUE;
        add_Word(d_sc, d_p);
        printf("(GPU)M: %d\n", d_sc->M);
    }

}



__global__ void is_Sub_Code_Separating_kernel_3x(sub_Code_t*  d_sc, Word_t* d_p, int* d_esSep) {

    int n_Event = blockDim.x * blockIdx.x + threadIdx.x;

    int M = d_sc->M;
    int i, j, k;

    int Events_totales = nchoose3(M);

    Event_t Event;
    Event_t* ev = &Event;

    __shared__ int sep[MAX_THREADS];
    

    sep[threadIdx.x] = TRUE;
    __syncthreads();

    int block, pos;

    while (n_Event < Events_totales) {

        get_ijk(M, n_Event, &i, &j, &k);
       // printf("M: %2d, thread: %2d, i=%2d, j=%2d, k=%2d\n", M, n_Event, i, j, k);

        //if (DEPUR>DEPUR_2) printf("(%d,%d,%d,p)\n", i-1, j-1, k-1);
        recargar_Event(ev, d_sc->p[i-1], d_sc->p[j-1], d_sc->p[k-1], d_p);
        if ( is_Event_Separating(ev, &block, &pos) ) {
            if (DEPUR>DEPUR_3) printf("Event i-j-k Separating. block: %d, pos: %d\n", block, primer_Uno(pos));
        } else {
            if (DEPUR>DEPUR_3) printf("Event i-j-k no Separating");
            sep[threadIdx.x]=FALSE;
            break;
        }

        //if (DEPUR>DEPUR_2) printf("(%d,%d,%d,p)\n", i-1, k-1, j-1);
        recargar_Event(ev, d_sc->p[i-1], d_sc->p[k-1], d_sc->p[j-1], d_p);
        if ( is_Event_Separating(ev, &block, &pos) ) {
            if (DEPUR>DEPUR_3) printf("Event i-k-j Separating. block: %d, pos: %d\n", block, primer_Uno(pos));
        } else {
            if (DEPUR>DEPUR_3) printf("Event i-k-j no Separating");
            sep[threadIdx.x]=FALSE;
            break;
        }

        //if (DEPUR>DEPUR_2) printf("(%d,%d,%d,p)\n", j-1, k-1, i-1);
        recargar_Event(ev, d_sc->p[j-1], d_sc->p[k-1], d_sc->p[i-1], d_p);
        if ( is_Event_Separating(ev, &block, &pos) ) {
            if (DEPUR>DEPUR_3) printf("Event j-k-i Separating. block: %d, pos: %d\n", block, primer_Uno(pos));
        } else {
            if (DEPUR>DEPUR_3) printf("Event j-k-i no Separating");
            sep[threadIdx.x]=FALSE;
            break;
        }
    
        n_Event += blockDim.x * gridDim.x;

    }  // while(Event_n<Events_totales)

    __syncthreads();



    for (int tam = blockDim.x; tam > 1; tam = (tam+1)/2) {
        int lim = tam/2;
        int inc = lim + (tam & 0x01);
        if (threadIdx.x < lim) {
            sep[threadIdx.x] = sep[threadIdx.x] && sep[threadIdx.x+inc];
        }
        __syncthreads();
    }
    if (threadIdx.x==0) {
        if (!sep[0]) {
            *d_esSep=FALSE;
        }
    }

} // is_Sub_Code_Separating_kernel






__global__ void is_Sub_Code_Separating_kernel(sub_Code_t*  d_sc, Word_t* d_p, int* d_esSep) {


    int n_Event = blockDim.x * blockIdx.x + threadIdx.x;
    int n_Event_base; 

    int M = d_sc->M;
    int i, j, k;

    int Events_totales = 3 * nchoose3(M);

    Event_t Event;
    Event_t* ev = &Event;

    __shared__ int sep[MAX_THREADS];
    

    sep[threadIdx.x] = TRUE;
    __syncthreads();

    int block, pos;
    char *Event_str;

    while (n_Event < Events_totales) {

        
        n_Event_base = n_Event / 3;
        get_ijk(M, n_Event_base, &i, &j, &k);
       // printf("M: %2d, thread: %2d, i=%2d, j=%2d, k=%2d\n", M, n_Event, i, j, k);

        int sub_Event = n_Event % 3;

        switch (sub_Event) {
            case 0: 
                //if (DEPUR>DEPUR_2) printf("(%d,%d,%d,p)\n", i-1, j-1, k-1);
                Event_str = (char*)"i-j-k";
                recargar_Event(ev, d_sc->p[i-1], d_sc->p[j-1], d_sc->p[k-1], d_p);
                break;
            case 1:
                //if (DEPUR>DEPUR_2) printf("(%d,%d,%d,p)\n", i-1, k-1, j-1);
                Event_str = (char*)"i-k-j";
                recargar_Event(ev, d_sc->p[i-1], d_sc->p[k-1], d_sc->p[j-1], d_p);       
                break;
            case 2:
                //if (DEPUR>DEPUR_2) printf("(%d,%d,%d,p)\n", j-1, k-1, i-1);
                Event_str = (char*)"j-k-i";
                recargar_Event(ev, d_sc->p[j-1], d_sc->p[k-1], d_sc->p[i-1], d_p);
                break;
        }

        if ( is_Event_Separating(ev, &block, &pos) ) {
            if (DEPUR>DEPUR_3) printf("Event %s Separating. block: %d, pos: %d\n", Event_str, block, primer_Uno(pos));
        } else {
            if (DEPUR>DEPUR_3) printf("Event %s no Separating", Event_str);
            sep[threadIdx.x]=FALSE;
            break;
        }

        n_Event += blockDim.x * gridDim.x;

    }  // while(Event_n<Events_totales)

    __syncthreads();



    for (int tam = blockDim.x; tam > 1; tam = (tam+1)/2) {
        int lim = tam/2;
        int inc = lim + (tam & 0x01);
        if (threadIdx.x < lim) {
            sep[threadIdx.x] = sep[threadIdx.x] && sep[threadIdx.x+inc];
        }
        __syncthreads();
    }
    if (threadIdx.x==0) {
        if (!sep[0]) {
            *d_esSep=FALSE;
        }
    }

} // is_Sub_Code_Separating_kernel