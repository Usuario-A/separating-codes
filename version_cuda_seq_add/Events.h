
#ifndef __EventS_H__
#define __EventS_H__

#include "general.h"
#include "Words.h"

typedef struct Event_t {
  Word_t* a;
  Word_t* b;
  Word_t* c;
  Word_t* d;
} Event_t;

__host__ __device__ Event_t* new_Event(Word_t* a, Word_t* b, Word_t *c, Word_t *d);

__host__ __device__ Event_t* recargar_Event(Event_t* ev, Word_t* a, Word_t* b, Word_t *c, Word_t *d);

__host__ __device__ Event_t* del_Event(Event_t* ev);

__host__ __device__ int is_Event_Separating(Event_t* ev, int *bloque, int *pos); 

__host__ __device__ int is_Event_Word_Separating(TYPE_DEC a, TYPE_DEC b, TYPE_DEC c, TYPE_DEC d, int *pos);

__host__ __device__ void print_Event_Bin(Event_t* ev);
__host__ __device__ void print_Event_Dec(Event_t* ev);

#endif