#include "pi.h"

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
