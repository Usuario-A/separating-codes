#ifndef __WordS_H__
#define __WordS_H__


#include "general.h"

// TYPE_BIN serán enteros sin signo
#define TYPE_BIN unsigned int
// TYPE_DEC serán enteros sin signo
#define TYPE_DEC unsigned int

// TYPE_DEC almacenará 32 bits
#define BITS_PER_TYPE_DEC 32
// El bit más significativo MSB del TYPE_DEC (unsigned int)
#define MSB_TYPE_DEC 0x80000000U

// El formato de los enteros sin signo (UINT), siendo
// el máximo valor UINT_MAX=4294967295, 
// ocupará ceil(log10(UINT_MAX))=10 digitos decimales
#define FMT_UINT "%10u"

// Tipo Word: estructura con 
// n: número de bits
// N: número de UINTs 
// v: vector [N] de UINTs
typedef struct Word_t {
  int n;
  int N;
  TYPE_DEC* v;
} Word_t;


// Plantillas

__host__ __device__ int nBits2nWords(int n);

__host__ __device__ Word_t* new_Word(int n);
__host__ __device__ Word_t* del_Word(Word_t* p);


__host__ __device__ void printWordDec(Word_t* p);
__host__ __device__ void printWordBin(Word_t* p);

__host__ __device__ void cBin2cDec (int n, TYPE_BIN* cBin, int N, TYPE_DEC* cDec);
__host__ __device__ void cDec2cBin (int N, TYPE_DEC* cDec, int n, TYPE_BIN* cBin);

__host__ __device__ int primer_Uno(int i);


TYPE_BIN* rand_Word_bin(int n, TYPE_BIN* vBin);
Word_t* rand_Word_Dec(int n);


#endif
