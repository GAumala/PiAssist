#include <stdio.h>    // Used for printf() statements
#include <stdlib.h>
#include <string.h>
#include <wiringPi.h> // Include WiringPi library!
#include "pi.h"

int pins[10];


int *get_bits_from_int(int byte, int bits_wanted){
  int *bits = malloc(sizeof(int)*bits_wanted); //4 bits or 3 bits...

  for (int i = 0; i < bits_wanted; i++) {
    int mask = 1<<i; // 00000001 in 1st iteration..
    int masked_byte = byte & mask;
    int bit = masked_byte>>i;
    bits[i] = bit;
  }
  return bits;
}

void write_bytes_to_pi(int pins[], int **values, int length_lista){
  for (int i; i < length_lista; i++) {
    //arrows
    int *arrows = get_bits_from_int(values[i][0], 4);
    //punchs
    int *punchs = get_bits_from_int(values[i][1], 3);
    //kicks
    int *kicks = get_bits_from_int(values[i][2], 3);

    int *total = malloc(10*sizeof(int));
    memcpy(total, arrows, 4*sizeof(int));
    memcpy(total, punchs, 3*sizeof(int));
    memcpy(total, kicks, 3*sizeof(int));

    write(pins, total);
    delay(10);
  }
}

int initialize_array_from_file(int pins[]){
  FILE *file_pins = fopen("pins_order.txt", "r");
  char* buffer, *token = 0;
  int length;
  if(file_pins){
    fseek(file_pins, 0, SEEK_END);
    length = ftell(file_pins);
    buffer = malloc(length);
    if(buffer){
      fseek(file_pins, SEEK_SET, 0);
      fread(buffer, 1, length, file_pins);
      token = strtok(buffer, ",");
      int i = 0;
      while(token != NULL && i <10){
        /* printf("%s\n", token); */
        pins[i] = atoi(token);
        i++;
        token = strtok(NULL, ",");
      }
      return 1;
    } else{
      printf("empty buffer...\n");
      return 0;
    }
  }else{
    printf("The file could not be read...\n");
    return 0;
  }

}

void setup(int pins[]){

  wiringPiSetupGpio(); // Initialize wiringPi -- using Broadcom pin numbers
  for (int i = 0; i < 10; i++) {
    pinMode(pins[i], OUTPUT);
  }
  printf("Setup finished...");
}

void write(int pins[], int valores[]){
  for (int i = 0; i < 10; i++) {
    digitalWrite(pins[i], valores[i]);
  }
}

void init_lista_movimientos(int **valores, int dim_x){
  int dim_y = 3;
  int i,j,k;
  int **data;
  data = (int **) malloc(sizeof(int *) * dim_x);
  for (k = 0; k < dim_x; k++) {
    data[k] = (int *) malloc(sizeof(int) * dim_y);
  }

  for (i = 0; i < dim_x; i++) {
    for (j = 0; j < dim_y; j++) {
      data[i][j] = 0; // filling the data with 0s...
    }
  }
  valores = data;
}

int main(int argc, char *argv[]){
  int LENGTH = 10; //length representa la longitud que tiene la lista.
  int **valores;
  init_lista_movimientos(valores, LENGTH); // se inicializa la lista.
  int error = initialize_array_from_file(pins); //se cargan los numeros de los pins de archivo en array pins.

  if(error == -0){
    printf("Error loading pins...\n");
    return 0;
  }

  setup(pins);

    while(1){
      write_bytes_to_pi(pins, valores, LENGTH); //we keep writing bytes to the pins the whole time...
    }

  return 0;
}
