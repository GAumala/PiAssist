#include <stdio.h>

int initialize_array_from_file(int pins[]);
void write(int pins[], int valores[]);
void setup(int pins[]);
int *get_bits_from_int(int n, int bits_wanted);
void write_bytes_to_pi(int pins[], int **values, int length_lista);
void init_lista_movimientos(int **valores, int dim_x); //dim_y es de 3 siempre.

