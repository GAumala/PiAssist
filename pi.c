#include <stdio.h>    // Used for printf() statements
#include <stdlib.h>
#include <string.h>
#include <wiringPi.h> // Include WiringPi library!
#include "pi.h"

int pins[10];

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

int main(int argc, char *argv[]){
  int valores[10];
  int error = initialize_array_from_file(pins);

  if(error == -0){
    printf("Error loading pins...\n");
    return 0;
  }

  setup(pins);

  //escribimos....
    while(1){
      write(pins, valores);
      delay(10);
    }

  return 0;
}
