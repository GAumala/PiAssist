#include "gpio.h"

typedef enum {START, RUNNING, FINISH} TAS_STATE;

FrameInput *input_list;
int input_count, it;
TAS_STATE state;

void setup_gpio_pins() {
	wiringPiSetupGpio(); // Initialize wiringPi -- using Broadcom pin numbers
	pinMode(DOWN_PIN, OUTPUT);
	pinMode(UP_PIN, OUTPUT);
	pinMode(LEFT_PIN, OUTPUT);
	pinMode(RIGHT_PIN, OUTPUT);
	pinMode(LP_PIN, OUTPUT);
	pinMode(MP_PIN, OUTPUT);
	pinMode(HP_PIN, OUTPUT);
	pinMode(LK_PIN, OUTPUT);
	pinMode(MK_PIN, OUTPUT);
	pinMode(HK_PIN, OUTPUT);
	pinMode(CLOCK_PIN, OUTPUT);
}

void gpio_write(uint8_t array[]) {
	for (int i = 0; i < INPUTS_COUNT; i++) {
		switch (i) {
			case LEFT_PIN_INDEX:
				digitalWrite(LEFT_PIN, array[i]); 
				break;
			case RIGHT_PIN_INDEX:
				digitalWrite(RIGHT_PIN, array[i]); 
				break;
			case DOWN_PIN_INDEX:
				digitalWrite(DOWN_PIN, array[i]); 
				break;
			case UP_PIN_INDEX:
				digitalWrite(UP_PIN, array[i]); 
				break;
			case LP_PIN_INDEX:
				digitalWrite(LP_PIN, array[i]); 
				break;
			case MP_PIN_INDEX:
				digitalWrite(MP_PIN, array[i]); 
				break;
			case HP_PIN_INDEX:
				digitalWrite(HP_PIN, array[i]); 
				break;
			case LK_PIN_INDEX:
				digitalWrite(LK_PIN, array[i]); 
				break;
			case MK_PIN_INDEX:
				digitalWrite(MK_PIN, array[i]); 
				break;
			case HK_PIN_INDEX:
				digitalWrite(HK_PIN, array[i]); 
				break;
		}
	}
}

void on_new_frame(void) {
	if (state == RUNNING) {
        if (it < input_count) {
			uint8_t array[INPUTS_COUNT];
			frame_input_fill_array(input_list[it], array);
			gpio_write(array);
			it++;
        } else 
			state = FINISH;
    } else if (state == START) {
		state = RUNNING;
    }
}


int run_gpio_tas(FrameInput *list, int count) {
	input_list = list;
	count = count;
	it = 0;
    state = START;
	
	setup_gpio_pins();
    if ( wiringPiISR (CLOCK_PIN, INT_EDGE_BOTH, &on_new_frame) < 0 ) {
        fprintf (stderr, "Unable to setup ISR: %s\n", strerror (errno));
        return 1;
    }

  while ( state != FINISH ) {  }

  return 0;
}
