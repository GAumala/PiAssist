#include "gpio.h"
#include "printd.h"

#ifdef SIMULATION
	#define WRITE_TO_GPIO fake_digitalWrite
#else
	#define WRITE_TO_GPIO digitalWrite
#endif


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

void fake_digitalWrite(int pinNumber, int value) {
	if (value)
		printf("turn on pin #%i\n", pinNumber);
	else
		printf("turn off pin #%i\n", pinNumber);
}

void gpio_write(uint8_t array[]) {
	for (int i = 0; i < INPUTS_COUNT; i++) {
		switch (i) {
			case LEFT_PIN_INDEX:
				WRITE_TO_GPIO(LEFT_PIN, array[i]); 
				break;
			case RIGHT_PIN_INDEX:
				WRITE_TO_GPIO(RIGHT_PIN, array[i]); 
				break;
			case DOWN_PIN_INDEX:
				WRITE_TO_GPIO(DOWN_PIN, array[i]); 
				break;
			case UP_PIN_INDEX:
				WRITE_TO_GPIO(UP_PIN, array[i]); 
				break;
			case LP_PIN_INDEX:
				WRITE_TO_GPIO(LP_PIN, array[i]); 
				break;
			case MP_PIN_INDEX:
				WRITE_TO_GPIO(MP_PIN, array[i]); 
				break;
			case HP_PIN_INDEX:
				WRITE_TO_GPIO(HP_PIN, array[i]); 
				break;
			case LK_PIN_INDEX:
				WRITE_TO_GPIO(LK_PIN, array[i]); 
				break;
			case MK_PIN_INDEX:
				WRITE_TO_GPIO(MK_PIN, array[i]); 
				break;
			case HK_PIN_INDEX:
				WRITE_TO_GPIO(HK_PIN, array[i]); 
				break;
		}
	}
}

void init_pin_array(uint8_t array[]) {
	for (int i = 0; i < INPUTS_COUNT; i++) 
		array[i] = 0;
}

void on_new_frame(void) {
	if (state == RUNNING) {
        if (it < input_count) {
			uint8_t array[INPUTS_COUNT];
			init_pin_array(array);
			frame_input_fill_array(input_list[it], array);
			printd("==================== #%i\n", it);
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
	input_count = count;
	it = 0;
    state = START;
	printd("start\n");
	setup_gpio_pins();
    if ( wiringPiISR (CLOCK_PIN, INT_EDGE_BOTH, &on_new_frame) < 0 ) {
        fprintf (stderr, "Unable to setup ISR: %s\n", strerror (errno));
        return 1;
    }

	printd("end setup\n");
    while ( state != FINISH ) {  }

	printd("finish\n");
	return 0;
}
