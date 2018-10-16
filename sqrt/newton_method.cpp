#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <cstdio>
#include <cstdlib>
#include <algorithm>
#include <string.h>
#include "../timing.h"
#include "newton_method_ispc.h"

using namespace ispc;

extern void newton_method_serial(int input_size,
                float x_initial,
                float input[],
                float output[]);


void tester()
{
  printf("Running tests for newton method functions \n");
  float input[8], output_serial[8], output_foreach[8], output_tasks[8];
  input[0] = 0.32423f;
  input[1] = 1.35423f;
  input[2] = 2.12324f;
  input[3] = 3.12345f;
  input[4] = 4.41535f;
  input[5] = 5.23142f;
  input[6] = 6.14151f;
  input[7] = 7.94290f;
  newton_method_serial(8, 2.f, input, output_serial);
  newton_method_ispc(8, 2.f, input, output_foreach);
  newton_method_ispc_withtasks(8, 2.f, input, output_tasks);
  for (int i=0; i<8; i++){
      printf("Square root using built in function is            %lf\n", sqrt(input[i]));
      printf("Square root using newton_method_serial is         %lf\n", output_serial[i]);
      printf("Square root using newton_method_ispc is           %lf\n", output_foreach[i]);
      printf("Square root using newton_method_ispc_withtasks is %lf\n", output_tasks[i]);
  }
  printf("Testing complete\n");
}
// Global due to being to large for the stack
float input[20000000], output_serial[20000000], output_foreach[20000000], output_tasks[20000000];

int main()
{
  tester();
  int array_size = 20000000; // change to 2000000;
  // float input[array_size], output_serial[array_size], output_foreach[array_size], output_tasks[array_size];
  for (int i=0; i<array_size; i++){
      input[i] = 0.f + static_cast <float> (rand()) /( static_cast <float> (RAND_MAX/(8)));
  }
  printf("Running newton_method_serial\n");
  reset_and_start_timer();
  
  newton_method_serial(array_size, 2.f, input, output_serial);
  double dt = get_elapsed_mcycles();
  printf("Complete after %.3f million cycles\n", dt);


  printf("Running newton_method_ispc\n");
  reset_and_start_timer();

  newton_method_ispc(array_size, 2.f, input, output_foreach);
  dt = get_elapsed_mcycles();
  printf("Complete after %.3f million cycles\n", dt);


  printf("Running newton_method_ispc_withtasks\n");
  reset_and_start_timer();

  newton_method_ispc_withtasks(array_size, 2.f, input, output_tasks);
  dt = get_elapsed_mcycles();
  printf("Complete after %.3f million cycles\n", dt);



  return 0;
}
