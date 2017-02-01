#include <check.h>
#include "../pi.h"
#include <stdlib.h>




/*
  Here we check if our array of pins is properly filled from the file pins_order.txt.
*/
START_TEST(initialize_array_from_file_test){
  uint8_t pins[10];
  int error;
  error = initialize_array_from_file(pins);
  ck_assert_int_eq(error, 1);
  ck_assert_int_eq(pins[0], 2);
  ck_assert_int_eq(pins[1], 3);
  ck_assert_int_eq(pins[2], 4);
  ck_assert_int_eq(pins[3], 14);
  ck_assert_int_eq(pins[4], 15);
  ck_assert_int_eq(pins[5], 18);
  ck_assert_int_eq(pins[6], 17);
  ck_assert_int_eq(pins[7], 27);
  ck_assert_int_eq(pins[8], 22);
  ck_assert_int_eq(pins[9], 23);
}
END_TEST

/*
  Here we check if the queue is being filled with the proper number of elements...
 */
START_TEST(fill_queue_test){
  char input_values[11] = "1,2,3,4,5,6";
  head_t head;
  int rows;
  TAILQ_INIT(&head);
  rows = fill_queue(&head, input_values);
  ck_assert_int_eq(rows, 2);
}
END_TEST

/*
  Here we check ...
*/
START_TEST(write_bytes_test){
  char input_values[11] = "1,2,3,4,5,6";
  head_t head;
  TAILQ_INIT(&head);
  fill_queue(&head, input_values);

  struct node *bytes_to_write;
  struct node *tmp_bytes_to_write;

  //here we check the first row 123
  bytes_to_write = TAILQ_FIRST(&head);
  tmp_bytes_to_write = TAILQ_NEXT(bytes_to_write, nodes);
  /* write(pins, bytes_to_write->pin_values); //escribimos y luego desencolamos y liberamos memoria. */
  //arrows
  uint8_t *arrows = (bytes_to_write->pin_values)[0];
  //punchs
  uint8_t *punchs = (bytes_to_write->pin_values)[1];
  //kicks
  uint8_t *kicks = (bytes_to_write->pin_values[2]);

  uint8_t *total = malloc(10*sizeof(uint8_t));

  ck_assert_int_eq(arrows[0], 1);
  ck_assert_int_eq(arrows[1], 0);
  ck_assert_int_eq(arrows[2], 0);
  ck_assert_int_eq(arrows[3], 0);
  ck_assert_int_eq(punchs[0], 0);
  ck_assert_int_eq(punchs[1], 1);
  ck_assert_int_eq(punchs[2], 0);
  ck_assert_int_eq(kicks[0], 1);
  ck_assert_int_eq(kicks[1], 1);
  ck_assert_int_eq(kicks[2], 0);
  // here we check the 2nd row.
  bytes_to_write = tmp_bytes_to_write;

  arrows = (bytes_to_write->pin_values)[0];
  //punchs
  punchs = (bytes_to_write->pin_values)[1];
  //kicks
  kicks = (bytes_to_write->pin_values[2]);
  ck_assert_int_eq(arrows[0], 0);
  ck_assert_int_eq(arrows[1], 0);
  ck_assert_int_eq(arrows[2], 1);
  ck_assert_int_eq(arrows[3], 0);
  ck_assert_int_eq(punchs[0], 1);
  ck_assert_int_eq(punchs[1], 0);
  ck_assert_int_eq(punchs[2], 1);
  ck_assert_int_eq(kicks[0], 0);
  ck_assert_int_eq(kicks[1], 1);
  ck_assert_int_eq(kicks[2], 1);
  free(bytes_to_write);

}
END_TEST



Suite * queue_suite(void)
{
  Suite *s;
  TCase *tc_core;
  s = suite_create("Queue");

  /* Core test case */
  tc_core = tcase_create("Core");

  tcase_add_test(tc_core, fill_queue_test);
  tcase_add_test(tc_core, initialize_array_from_file_test);
  tcase_add_test(tc_core, write_bytes_test);
  suite_add_tcase(s, tc_core);

  return s;
  }

int main(int argc, char *argv[])
{

  int number_failed;
  Suite *s;
  SRunner *sr;

  s = queue_suite();
  sr = srunner_create(s);
  srunner_run_all(sr, CK_NORMAL);
  number_failed = srunner_ntests_failed(sr);
  srunner_free(sr);
  return (number_failed == 0) ? EXIT_SUCCESS : EXIT_FAILURE;
}
