#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <stdlib.h>
#include <wiringPi.h>

#define CLOCK_PIN 24

int isr_started = 0;
int it = 0;

int RAY[17] = {
	1,
    1,
    0,
    0,
    0,
    0,
    1,
    1,
    0,
    0,
    0,
    0,
    0,
    0,
    1,
    1,
    0,
};


	

void myInterrupt(void) {
    if (isr_started) {
        if (it < 17) {
            if (RAY[it]) {
                 digitalWrite(17, 1);
            } else {
                 digitalWrite(17, 0);
            }
        }
		it++;
    } else {
		isr_started = 1;
    }
}

int main(void) {
  wiringPiSetupGpio(); // Initialize wiringPi -- using Broadcom pin numbers
    pinMode(17, OUTPUT);
  pinMode(CLOCK_PIN, INPUT);

  if ( wiringPiISR (CLOCK_PIN, INT_EDGE_BOTH, &myInterrupt) < 0 ) {
      fprintf (stderr, "Unable to setup ISR: %s\n", strerror (errno));
      return 1;
  }

  while ( 1 ) {  }

  return 0;
}



