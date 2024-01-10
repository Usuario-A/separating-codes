

#include <stdio.h>
#include <stdlib.h>
#include "Events.h"

// Reserva espacio para un Event y referencia a las cuatro Words en cuestión
__host__ __device__ Event_t* new_Event(Word_t* a, Word_t* b, Word_t *c, Word_t *d) {
  Event_t* ev = (Event_t*) malloc(sizeof(Event_t));
  ev->a = a;
  ev->b = b;
  ev->c = c;
  ev->d = d;
  return ev;
}


// Idem que new_Event, pero sin reservar espacio de nuevo: aprovecha el ya reservado
__host__ __device__ Event_t* recargar_Event(Event_t* ev, Word_t* a, Word_t* b, Word_t *c, Word_t *d) {
  ev->a = a;
  ev->b = b;
  ev->c = c;
  ev->d = d;
  return ev;
}

// Libera el espacio destinado a un Event
__host__ __device__ Event_t* del_Event(Event_t* ev) {
  free(ev);
  return ev;
}


// Comprueba si cuatro números decimales (32 bits cada uno) pueden considerarse "Separatings"
__host__ __device__ int is_Event_Word_Separating(TYPE_DEC a, TYPE_DEC b, TYPE_DEC c, TYPE_DEC d, int *pos) {
  if (DEPUR>DEPUR_5) printf("is_Word_Separating? a=" FMT_UINT ", b=" FMT_UINT ", c=" FMT_UINT ", d=" FMT_UINT "\n", a, b, c, d);
  return (*pos =  (a^c)&(b^d)&(~(a^b))) != 0;
}

// Comprueba que un Event es Separating (basándose en la separabilidad de cada entero de los
// que se componga)
__host__ __device__ int is_Event_Separating(Event_t* ev, int *bloque, int *pos) {
  int N = nBits2nWords( ev->a->n );
  for (int i = 0; i < N; i++ ) {
    if ( is_Event_Word_Separating(ev->a->v[i], ev->b->v[i], ev->c->v[i], ev->d->v[i], pos) ) {
      *bloque = i;
      if (DEPUR>DEPUR_5) { print_Event_Bin(ev); printf("\n"); }
      return TRUE;
    }
  }
  return FALSE;
}

// Imprime en pantalla un Event en formato binario
__host__ __device__ void print_Event_Bin(Event_t* ev) {
  printWordBin(ev->a);
  printWordBin(ev->b);
  printWordBin(ev->c);
  printWordBin(ev->d);
}

// Imprime en pantalla un Event en formato decimal
__host__ __device__ void print_Event_Dec(Event_t* ev) {
  printWordDec(ev->a);
  printWordDec(ev->b);
  printWordDec(ev->c);
  printWordDec(ev->d);
}


