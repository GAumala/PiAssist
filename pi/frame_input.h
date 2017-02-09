#ifndef _FRAME_INPUT_H_
#define _FRAME_INPUT_H_

#define LEFT_PIN_INDEX  0
#define RIGHT_PIN_INDEX 1
#define DOWN_PIN_INDEX  2
#define UP_PIN_INDEX    3
#define LP_PIN_INDEX    4
#define MP_PIN_INDEX    5
#define HP_PIN_INDEX    6
#define LK_PIN_INDEX    7
#define MK_PIN_INDEX    8
#define HK_PIN_INDEX    9

#define DOWN_INPUT       1
#define RIGHT_INPUT      2
#define LEFT_INPUT       3
#define UP_INPUT         4
#define DOWN_LEFT_INPUT  5
#define DOWN_RIGHT_INPUT 6
#define UP_LEFT_INPUT    7
#define UP_RIGHT_INPUT   8

#define LP_INPUT      10
#define MP_INPUT      11
#define HP_INPUT      12
#define LPMP_INPUT    13
#define MPHP_INPUT    14
#define LPHP_INPUT    15
#define LPMPHP_INPUT  16

#define LK_INPUT      18
#define MK_INPUT      19
#define HK_INPUT      20
#define LKMK_INPUT    21
#define MKHK_INPUT    22
#define LKHK_INPUT    23
#define LKMKHK_INPUT  24

#define INPUTS_COUNT 10

#include <stdint.h>
#include <stdio.h>

typedef struct {
	uint8_t arrows;
	uint8_t punches;
	uint8_t kicks;
} FrameInput;

FrameInput frame_input_new(uint8_t arrows, uint8_t punches, uint8_t kicks);

void frame_input_fill_array(FrameInput input, uint8_t array[]);

int frame_input_fill_array_from_stdin(FrameInput array[]); 

#endif
