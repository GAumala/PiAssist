#include <stdio.h>    // Used for printf() statements
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <wiringPi.h> // Include WiringPi library!
#include "pi.h"

uint8_t pins[10];


uint8_t *get_bits_from_int(uint8_t byte, uint8_t bits_wanted){
  uint8_t *bits = malloc(sizeof(uint8_t)*bits_wanted); //4 bits or 3 bits...

  for (uint8_t i = 0; i < bits_wanted; i++) {
    uint8_t mask = 1<<i; // 00000001 in 1st iteration..
    uint8_t masked_byte = byte & mask;
    uint8_t bit = masked_byte>>i;
    bits[i] = bit;
  }
  return bits;
}

void write_bytes_to_pi(uint8_t pins[], head_t *head){
  struct node *bytes_to_write;
  struct node *tmp_bytes_to_write;

  for (bytes_to_write = TAILQ_FIRST(head); bytes_to_write != NULL; bytes_to_write = tmp_bytes_to_write) {
    tmp_bytes_to_write = TAILQ_NEXT(bytes_to_write, nodes);
    /* write(pins, bytes_to_write->pin_values); //escribimos y luego desencolamos y liberamos memoria. */
    //arrows
    uint8_t *arrows = (bytes_to_write->pin_values)[0];
    //punchs
    uint8_t *punchs = (bytes_to_write->pin_values)[1];
    //kicks
    uint8_t *kicks = (bytes_to_write->pin_values[2]);

    uint8_t *total = malloc(10*sizeof(uint8_t));
    memcpy(total, arrows, 4*sizeof(uint8_t));
    memcpy(total, punchs, 3*sizeof(uint8_t));
    memcpy(total, kicks, 3*sizeof(uint8_t));

    write(pins, total);
    free(bytes_to_write);

    delay(16); //delay de 16 ms.
  }
}


uint8_t initialize_array_from_file(uint8_t pins[]){
  FILE *file_pins = fopen("pins_order.txt", "r");
  char* buffer, *token = 0;
  uint8_t length;
  if(file_pins){
    fseek(file_pins, 0, SEEK_END);
    length = ftell(file_pins);
    buffer = malloc(length);
    if(buffer){
      fseek(file_pins, SEEK_SET, 0);
      fread(buffer, 1, length, file_pins);
      token = strtok(buffer, ",");
      uint8_t i = 0;
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

void setup(uint8_t pins[]){

  wiringPiSetupGpio(); // Initialize wiringPi -- using Broadcom pin numbers
  for (uint8_t i = 0; i < 10; i++) {
    pinMode(pins[i], OUTPUT);
  }
  printf("Setup finished...");
}

void write(uint8_t pins[], uint8_t valores[]){
  for (uint8_t i = 0; i < 10; i++) {
    digitalWrite(pins[i], valores[i]);
  }
}


void fill_queue(head_t *head, char* input_values){
  char* token = 0;

  token = strtok(input_values, ",");
  while(token != NULL){

    uint8_t **c = malloc(sizeof(uint8_t *)*3);
    struct node *e = malloc(sizeof(struct node));

    if (e == NULL)
      {
        fprintf(stderr, "malloc failed");
        exit(EXIT_FAILURE);
      }
      /* c[i] = strtol(token, NULL, 8); */
    c[0] = get_bits_from_int(strtol(token, NULL, 8), 4);
    token = strtok(NULL, ",");
    c[1] = get_bits_from_int(strtol(token, NULL, 8), 3);
    token = strtok(NULL, ",");
    c[2] = get_bits_from_int(strtol(token, NULL, 8), 3);
      token = strtok(NULL, ",");

    e->pin_values = c;
    TAILQ_INSERT_TAIL(head, e, nodes);
    e = NULL;

  }
}


int main(int argc, char *argv[]){

  char* input_values = (char*)argv[1];
  head_t head;
  /* Define a pointer to an item in the tail queue. */
  struct node *bytes_to_write;

  /* In some cases we have to track a temporary item. */
  struct node *tmp_bytes_to_write;
  TAILQ_INIT(&head);

  fill_queue(&head, input_values);
  write_bytes_to_pi(pins, &head);
  printf("\n Success writing values to pi....\n");
  return 0;
}
