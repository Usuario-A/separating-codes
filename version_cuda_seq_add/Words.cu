
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#include "Words.h"

/*

Convenio: 
  - Los vectores se enumeran simbólicamente de izquierda a derecha:
     [0] [1] ... []
  - Los bits se agrupan de 32 en 32 (BITS_PER_TYPE_DEC) con la siguiente correspondencia:
     vector binario:  [0] [1] ... [31] [32] [33] ... [63]   
     vector decimal:  [       0      ] [        1       ]

*/

/* Pasa de cantidad de bits a cantidad de Words necesarias para contenerlos */
__host__ __device__ int nBits2nWords(int n){
  return (int) ceil( (double)n / BITS_PER_TYPE_DEC );
}

/* Genera una nueva Word de n bits*/
__host__ __device__ Word_t* new_Word(int n){
  Word_t* p = (Word_t*) malloc(sizeof(Word_t)); 
  p->n = n;
  p->N = nBits2nWords(n);
  p->v = (TYPE_DEC*) malloc(p->N*sizeof(TYPE_DEC));
  return p;
}

/* Libera memoria de variable de tipo Word_t */
__host__ __device__ Word_t* del_Word(Word_t* p){
  free(p->v);
  free(p);
  return p;
}


/* Imprime Word en formato decimal */
__host__ __device__ void printWordDec(Word_t* p) {
  for ( int i = 0; i<p->N; i++ ) {
    printf(FMT_UINT " ", p->v[i]);
  }
  printf("\n");
}


/* Imprime Word en formato binario */
__host__ __device__ void printWordBin(Word_t* p) {
  int n = p->n;
  int N = nBits2nWords(p->n);

  //TYPE_BIN cBin[n];
  TYPE_BIN* cBin = (TYPE_BIN*) malloc(sizeof(TYPE_BIN)*p->n);

  cDec2cBin (N, p->v, n, cBin);

  for ( int i=0; i < n%BITS_PER_TYPE_DEC; i++ ) {
    printf("%d",  ((cBin[i]!=0)?1:0) );
    if (n%BITS_PER_TYPE_DEC-i==5) printf(" ");   
    if (i==n%BITS_PER_TYPE_DEC-1) printf("  ");
  }
  
  for ( int i = n%BITS_PER_TYPE_DEC; i<n; i++ ) {
    printf("%d",  ((cBin[i]!=0)?1:0) );
    if (!((i-n%BITS_PER_TYPE_DEC+1)%BITS_PER_TYPE_DEC)) printf("  "); 
    else if (!((i-n%BITS_PER_TYPE_DEC+1)%4)) printf(" ");
    
  }
  printf("\n");
  free(cBin);

}


/* De vector binario (vector de n bits) a vector decimal (vector de N decimales), codificando la misma información.
 */
__host__ __device__ void cBin2cDec (int n, TYPE_BIN* cBin, int N, TYPE_DEC* cDec) {
 
  int cont = 0;
  int j_inic = 0;

  TYPE_DEC aux = 0;
  for ( int i = 0; i < n % BITS_PER_TYPE_DEC; i++ ) {
    aux = (aux<<1) | (cBin[cont++]!=0); 
    j_inic = 1;
  }
  cDec[0] = aux;

  for ( int j = 0; j < n / BITS_PER_TYPE_DEC; j++ ) {
    aux = 0;
    for ( int i = 0; i < BITS_PER_TYPE_DEC; i++ ) {
        aux = (aux<<1) | (cBin[cont++]!=0); 
      }
    cDec[j+j_inic] = aux;
  }

}





/* De Word decimal (vector de N decimales) a Word binaria (vector de n bits), codificando la misma información. 
*/
__host__ __device__ void cDec2cBin (int N, TYPE_DEC* cDec, int n, TYPE_BIN* cBin) {

  int cont = 0;
  int j_inic = 0;

  TYPE_DEC mascara = 1 << ( (n % BITS_PER_TYPE_DEC)-1 );
  for ( int i = 0; i < n % BITS_PER_TYPE_DEC; i++ ) {
    cBin[cont++] = (cDec[0] & mascara) != 0;
    mascara >>= 1;
    j_inic = 1;
  }

  for ( int j = j_inic; j <=  n / BITS_PER_TYPE_DEC; j++ ) {
    mascara = MSB_TYPE_DEC;
    for ( int i = 0; i < BITS_PER_TYPE_DEC; i++ ) {
      cBin[cont++] = (cDec[j] & mascara) != 0;
      mascara >>= 1;
    }
  }

}


// Devuelve la posición del primer dígito binario a 1 del decimal i, 
// comenzando desde su LSB
__host__ __device__ int primer_Uno(int i) {
  Word_t* p = new_Word(BITS_PER_TYPE_DEC);
  p->v[0]=i;
  //TYPE_BIN cBin[p->n];
  TYPE_BIN* cBin = (TYPE_BIN*) malloc(sizeof(TYPE_BIN)*p->n);
  cDec2cBin(p->N, p->v, p->n, cBin);
  for (int j=0; j<p->n; j++) {
    if (cBin[j]!=0) {
      return j;
    }
  }
  free(cBin);
  return -1;
}




/** genera una Word aleatoria binaria */
TYPE_BIN* rand_Word_Bin(int n, TYPE_BIN* vBin) {
  for ( int i = 0; i < n; i++ ) {
    vBin[i] = (rand()>RAND_MAX/2)? 1 : 0;
  }
  return vBin;
}

/* Genera una Word aleatoria decimal */
Word_t* rand_Word_Dec(int n) {
  Word_t* p = new_Word(n);
  TYPE_BIN vBin[p->n];
  cBin2cDec(p->n, rand_Word_Bin(p->n, vBin), nBits2nWords(p->n), p->v);
  return p;
}