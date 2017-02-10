#include "frame_input.h"

FrameInput frame_input_new(uint8_t arrows, uint8_t punches, uint8_t kicks) {
	FrameInput f;
	f.arrows = arrows;
	f.punches = punches;
	f.kicks = kicks;
	return f;
}


void frame_input_fill_array(FrameInput input, uint8_t array[]) {
	switch (input.arrows) {
		case DOWN_INPUT:
        	array[DOWN_PIN_INDEX] = 1;
			break;
		case RIGHT_INPUT:
        	array[RIGHT_PIN_INDEX] = 1;
			break;
		case LEFT_INPUT:
        	array[LEFT_PIN_INDEX] = 1;
			break;
		case UP_INPUT:
        	array[UP_PIN_INDEX] = 1;
			break;
		case DOWN_LEFT_INPUT:
        	array[DOWN_PIN_INDEX] = 1;
        	array[LEFT_PIN_INDEX] = 1;
			break;
		case DOWN_RIGHT_INPUT:
        	array[DOWN_PIN_INDEX] = 1;
        	array[RIGHT_PIN_INDEX] = 1;
			break;
		case UP_LEFT_INPUT:
        	array[UP_PIN_INDEX] = 1;
        	array[LEFT_PIN_INDEX] = 1;
			break;
		case UP_RIGHT_INPUT:
        	array[UP_PIN_INDEX] = 1;
        	array[RIGHT_PIN_INDEX] = 1;
			break;
	}

	switch (input.punches) {
		case LP_INPUT:
			array[LP_PIN_INDEX] = 1;
			break;
		case MP_INPUT:
			array[MP_PIN_INDEX] = 1;
			break;
		case HP_INPUT:
			array[HP_PIN_INDEX] = 1;
			break;
		case LPMP_INPUT:
			array[LP_PIN_INDEX] = 1;
			array[MP_PIN_INDEX] = 1;
			break;
		case MPHP_INPUT:
			array[MP_PIN_INDEX] = 1;
			array[HP_PIN_INDEX] = 1;
			break;
		case LPHP_INPUT:
			array[LP_PIN_INDEX] = 1;
			array[HP_PIN_INDEX] = 1;
			break;
		case LPMPHP_INPUT:
			array[LP_PIN_INDEX] = 1;
			array[MP_PIN_INDEX] = 1;
			array[HP_PIN_INDEX] = 1;
			break;
	}

	switch (input.kicks) {
		case LK_INPUT:
			array[LK_PIN_INDEX] = 1;
			break;
		case MK_INPUT:
			array[MK_PIN_INDEX] = 1;
			break;
		case HK_INPUT:
			array[HK_PIN_INDEX] = 1;
			break;
		case LKMK_INPUT:
			array[LK_PIN_INDEX] = 1;
			array[MK_PIN_INDEX] = 1;
			break;
		case MKHK_INPUT:
			array[MK_PIN_INDEX] = 1;
			array[HK_PIN_INDEX] = 1;
			break;
		case LKHK_INPUT:
			array[LK_PIN_INDEX] = 1;
			array[HK_PIN_INDEX] = 1;
			break;
		case LKMKHK_INPUT:
			array[LK_PIN_INDEX] = 1;
			array[MK_PIN_INDEX] = 1;
			array[HK_PIN_INDEX] = 1;
			break;
	}
}

int frame_input_fill_array_from_stdin(FrameInput array[]) {
	int x, y, z;
	int i = 0;
	while (scanf("%d:%d:%d", &x, &y, &z) == 3) {
		array[i++] = frame_input_new(x, y, z);
	}
	return i;
}
