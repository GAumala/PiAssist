#ifndef _PI_H_
#define _PI_H_

#include <stdio.h>    // Used for printf() statements
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <wiringPi.h> // Include WiringPi library!
#include <sys/queue.h>

uint8_t pins[10];
struct node{
  uint8_t **pin_values;
  TAILQ_ENTRY(node) nodes;
};

typedef TAILQ_HEAD(head_s, node) head_t;

uint8_t initialize_array_from_file(uint8_t pins[]);
void write(uint8_t pins[], uint8_t valores[]);
void setup(uint8_t pins[]);
uint8_t *get_bits_from_int(uint8_t n, uint8_t bits_wanted);
int fill_queue(head_t *head, char* input_values);
void write_bytes_to_pi(uint8_t pins[], head_t *head);

#endif
