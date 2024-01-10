#include <stdio.h>

#include <cuda_runtime.h>

#include "general.h"
#include "Words.h"
#include "Events.h"
#include "subCodes.h"
#include "auxGPU.h"
#include "threads.h"
#include "results.h"




int main(void) {

    

    struct parametros datos;
    struct info results;

    unsigned int seed;
    seed = time(NULL);
    seed = 1;
    srand(seed);
    datos.seed = seed;


    // Control de MAX_THREADS
    int d;
    cudaDeviceProp prop;
    CUDA_CALL( cudaGetDevice(&d) );
    CUDA_CALL( cudaGetDeviceProperties(&prop, d) );
    if ( prop.maxThreadsPerBlock < MAX_THREADS ) {
        printf("Maxim number of threads por block (%d) is lower than needed (%d)", 
        prop.maxThreadsPerBlock, MAX_THREADS);
        exit(EXIT_FAILURE);
    }

    printf("name: %s\nmultiProcessorCount: %d\nmaxThreadsPerMultiprocessor: %d\nmaxThreadsPerBlock: %d\nmaxThreadsDim: (%d,%d,%d)\n", prop.name, prop.multiProcessorCount, prop.maxThreadsPerMultiProcessor, prop.maxThreadsPerBlock, prop.maxThreadsDim[0], 
    prop.maxThreadsDim[1],prop.maxThreadsDim[2]);


    strcpy(datos.name, prop.name);
    datos.multiProcessorCount = prop.multiProcessorCount;
    datos.maxThreadsPerMultiProcessor = prop.maxThreadsPerMultiProcessor;
    datos.maxThreadsPerBlock = prop.maxThreadsPerBlock;
    datos.maxThreadsDim[0] = prop.maxThreadsDim[0];
    datos.maxThreadsDim[1] = prop.maxThreadsDim[1];
    datos.maxThreadsDim[2] = prop.maxThreadsDim[2];



    //  Code word length
    int n = 128;

    datos.n = n;

    // Desired number of words
    int M = 300;
    datos.M = M;


    // Event inicial con las primeras 4 Words candiato
    Event_t* ev = new_Event(rand_Word_Dec(n), rand_Word_Dec(n), rand_Word_Dec(n), rand_Word_Dec(n));

    // Verificación de separabilidad de primer Event
    int block, pos;
    while (!is_Event_Separating(ev, &block, &pos)) {
        printf("Initial Event is not Separating\n");
        del_Event(ev);
        ev = new_Event(rand_Word_Dec(n), rand_Word_Dec(n), rand_Word_Dec(n), rand_Word_Dec(n));
    }
    printf("Initial Event is already Separating. block: %d, pos=%d\n", block, primer_Uno(pos));

    // subcódigo local
    sub_Code_t sc;
    sc.n = n;
    sc.N = nBits2nWords(n);
    sc.M = 0;

    // add first four words ódigo del primer Event Separating
    add_Word(&sc, ev->a);
    add_Word(&sc, ev->b);
    add_Word(&sc, ev->c);
    add_Word(&sc, ev->d);

    del_Event(ev);
    
    printf("*************\n");
    print_Sub_Code(&sc);
    printf("*************\n");


    // reflejo inicial del subCode del en la GPU
    sub_Code_t sc_aux;
    sc_aux.M = sc.M;
    sc_aux.N = sc.N;
    sc_aux.n = sc.n;

    
    // Cara en GPU de las Words del subcódigio inicial de 4 Words
    for (int i = 0; i < sc.M; i++) {
        // Carga del vector
        TYPE_DEC* d_v;
        printf("sizeof(TYPE_DEC)*sc.p[%d]=%d", i, sizeof(TYPE_DEC)*sc.p[i]->N);
        CUDA_CALL( cudaMalloc((void**)&d_v, sizeof(TYPE_DEC)*sc.p[i]->N) );        
        CUDA_CALL( cudaMemcpy(d_v, sc.p[i]->v, sizeof(TYPE_DEC)*sc.p[i]->N, cudaMemcpyHostToDevice ) );
        
        // Carga de la Word
        Word_t* d_p;
        CUDA_CALL( cudaMalloc((void**)&d_p, sizeof(Word_t)) );
        Word_t* p = new_Word(sc.p[i]->n);
        p->v = d_v;
        CUDA_CALL( cudaMemcpy(d_p, p, sizeof(Word_t), cudaMemcpyHostToDevice) );
        
        sc_aux.p[i] = d_p;
    }
    // Carga del subcódigo completamente inicializado
    sub_Code_t* d_sc;
    CUDA_CALL( cudaMalloc((void**)&d_sc, sizeof(sub_Code_t)) );
    CUDA_CALL( cudaMemcpy(d_sc, &sc_aux, sizeof(sub_Code_t), cudaMemcpyHostToDevice) );
    


    // Numero de Words aleatorias generadas no Separatings
    int n_no_sep=0;
    // Testigo local de separabilidad o no de Word candidato
    int esSep;
    // Testigo en GPU de separabilidad o no de Word candidato
    int* d_esSep = NULL;
    CUDA_CALL( cudaMalloc((void**)&d_esSep, sizeof(int)) );
    

    int cierto = TRUE;
    int* TRUE_ptr = &cierto;


    cudaEvent_t start_iteracion, stop_iteracion;
    CUDA_CALL( cudaEventCreate(&start_iteracion) );
    CUDA_CALL( cudaEventCreate(&stop_iteracion) );


    cudaEvent_t start_pre_kernel, stop_pre_kernel;
    CUDA_CALL( cudaEventCreate(&start_pre_kernel) );
    CUDA_CALL( cudaEventCreate(&stop_pre_kernel) );

    cudaEvent_t start_kernel, stop_kernel;
    CUDA_CALL( cudaEventCreate(&start_kernel) );
    CUDA_CALL( cudaEventCreate(&stop_kernel) );


    cudaEvent_t start_post_kernel, stop_post_kernel;
    CUDA_CALL( cudaEventCreate(&start_post_kernel) );
    CUDA_CALL( cudaEventCreate(&stop_post_kernel) );


    cudaEvent_t t_inic, t_fin;
    CUDA_CALL( cudaEventCreate(&t_inic) );
    CUDA_CALL( cudaEventCreate(&t_fin) );

    CUDA_CALL( cudaEventRecord(t_inic, 0) ); 

    float t_Word_Code_acum = 0.;

    // Generación de Words Separatings
    int cont = sc.M;
    int inic = cont + 1; 
    int i;
    for (i = 0; cont < M; i++) {
    
        /**/CUDA_CALL( cudaEventRecord(start_iteracion, 0) );
        /**/CUDA_CALL( cudaEventRecord(start_pre_kernel, 0) );


        // Generación de Word candidato
        Word_t* candidato = rand_Word_Dec(n);
        
        // Carga en GPU de Word candidato
        TYPE_DEC* d_v;
        CUDA_CALL( cudaMalloc((void**)&d_v, sizeof(TYPE_DEC)*candidato->N) );    
        CUDA_CALL( cudaMemcpy(d_v, candidato->v, sizeof(TYPE_DEC)*candidato->N, cudaMemcpyHostToDevice) );
        

        // Uso de candidato auxiliar para cargar en host el vector candidato que ya reside en GPU
        Word_t* candidato_aux = new_Word(n);
        free(candidato_aux->v);
        candidato_aux->v = d_v;      

        // Reserva de espacio de Word candidato en GPU
        Word_t* d_candidato;
        CUDA_CALL( cudaMalloc( (void**)&d_candidato, sizeof(Word_t) ) );  
        
        // Carga de candidato host en GPU
        CUDA_CALL( cudaMemcpy(d_candidato, candidato_aux, sizeof(Word_t), cudaMemcpyHostToDevice) );
        free(candidato_aux);


        // recarga de testigo de separabilidad en GPU a TRUE
        CUDA_CALL( cudaMemcpy(d_esSep, TRUE_ptr, sizeof(int), cudaMemcpyHostToDevice) );
        

        // Parametros arranque de kernel        
        int n_Events = 3 * nchoose3(sc.M);
        int threads_por_block = MIN(n_Events, MAX_THREADS);
        //threads_por_block = MIN(n_Events, 128);
        int blocks = ( n_Events + threads_por_block - 1 ) / threads_por_block;
        //blocks = MIN(blocks, 800);

        /**/results.n_Events[i] = n_Events;
        /**/results.blocks[i] = blocks;
        /**/results.threads[i] = threads_por_block;


        printf("n=%d, M=%d, Total Events=%d, <<<%dx%d>>>=%d\n", n, sc.M, n_Events, blocks, threads_por_block, blocks*threads_por_block);

        /**/CUDA_CALL( cudaEventRecord(stop_pre_kernel, 0) );
        /**/CUDA_CALL( cudaEventSynchronize(stop_pre_kernel) );
        /**/float t_pre_kernel; 
        /**/CUDA_CALL( cudaEventElapsedTime(&t_pre_kernel, start_pre_kernel, stop_pre_kernel) );
        
        /**/CUDA_CALL( cudaEventRecord(start_kernel, 0) );

        // Arranque de kernel
        is_Sub_Code_Separating_kernel<<<blocks,threads_por_block>>>(d_sc, d_candidato, d_esSep) ;
        
        /**/CUDA_CALL( cudaEventRecord(stop_kernel, 0) );
        /**/CUDA_CALL( cudaEventSynchronize(stop_kernel) );
        /**/float t_kernel; 
        /**/CUDA_CALL( cudaEventElapsedTime(&t_kernel, start_kernel, stop_kernel) );
        
        /**/CUDA_CALL( cudaEventRecord(start_post_kernel, 0) );

        // Carga de testigo de separabilidad de Word candidato en host
        CUDA_CALL( cudaMemcpy(&esSep, d_esSep, sizeof(int), cudaMemcpyDeviceToHost) );
        //printf("Candidate Separating? %s\n", ((esSep)?"TRUE":"FALSE"));

        /**/float t_post_kernel; 

        if (esSep) {
            add_Word(&sc, candidato);
            printf("(Host)M: %d\n", sc.M);

            // kernel que añade Word candidato como Word Separating
            d_add_Word<<<1,1>>>(d_sc, d_candidato);
            
            /**/CUDA_CALL( cudaEventRecord(stop_post_kernel, 0) );
            /**/CUDA_CALL( cudaEventSynchronize(stop_post_kernel) );
            /**/CUDA_CALL( cudaEventElapsedTime(&t_post_kernel, start_post_kernel, stop_post_kernel) );

            /**/results.t_Word_Code[cont] = t_Word_Code_acum + t_pre_kernel + t_kernel + t_post_kernel;
            cont++; 
            t_Word_Code_acum = 0;
        
        } else {
            del_Word(candidato);
            CUDA_CALL( cudaFree(d_v) );
            CUDA_CALL( cudaFree(d_candidato) );
            printf("(host)candidate not Separating\n");
            n_no_sep++;

            CUDA_CALL( cudaEventRecord(stop_post_kernel, 0) );
            CUDA_CALL( cudaEventSynchronize(stop_post_kernel) );
            CUDA_CALL( cudaEventElapsedTime(&t_post_kernel, start_post_kernel, stop_post_kernel) );

            t_Word_Code_acum += t_pre_kernel + t_kernel + t_post_kernel;
        }


        CUDA_CALL( cudaEventRecord(stop_iteracion, 0) );
        CUDA_CALL( cudaEventSynchronize(stop_iteracion) );

        float t_iteracion; 
        CUDA_CALL( cudaEventElapsedTime(&t_iteracion, start_iteracion, stop_iteracion) );
        

        results.Word_Code[i] = cont;
        results.Word[i] = inic + i;

        results.t_pre_kernel[i]  = t_pre_kernel;
        results.t_kernel[i]      = t_kernel;
        results.t_post_kernel[i] = t_post_kernel;

        results.t_Word[i] = t_pre_kernel + t_kernel + t_post_kernel;

        printf("i=%d\n", i);
        results.t_iteracion[i] = t_iteracion;

        
    } // for (int cont = 0;


    CUDA_CALL( cudaEventRecord(t_fin, 0) );
    CUDA_CALL( cudaEventSynchronize(t_fin) );
    float tx;
    CUDA_CALL( cudaEventElapsedTime(&tx, t_inic, t_fin) );

    printf("Simulation time:  %f s\n", tx/1000.);

    printf("Discarded: %d\n", n_no_sep);


    char fichero[256];


    sprintf(fichero, "cod%d.m",n);
    printf("Saving Code in %s\n", fichero);
    save_Code(&sc, fichero);

    
    sprintf(fichero, "results_cod%d.m",n);
    printf("Saving results in %s\n", fichero);
    guardar_results(fichero, &datos, &results, i, cont);

    /************************************/

    CUDA_CALL( cudaDeviceReset() );
    
    printf("End\n");
    return 0;
}
