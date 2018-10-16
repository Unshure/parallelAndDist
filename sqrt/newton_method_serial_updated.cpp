#include <math.h>
#include <stdio.h>
#include <stdlib.h>


void newton_method_serial(int input_size,
                float x_initial,
                float input[],
                float output[])
{
    // Computes the square root of each element in the values array and stores it in the output array
    // input_size should be set to the size of the input/output array
    // x0 is the initial guess for Newton's method

    static const float tolerance = 0.001f; // break tolerance is 10**-4

    for (int i=0; i<input_size; i++) {

        float S = input[i]; // value to find sqrt
        //printf("S: %lf\n", S);
        float x_0 = x_initial;
        //printf("x0: %lf\n",x_0);
        float x_1 = .5f * (x_0 + (S/x_0));
        //printf("x1: %lf\n",x_1);



        while (fabs(x_1-x_0)> tolerance) {
            x_0 = x_1;
            //printf("x0: %lf\n",x_0);
            x_1 = .5f * (x_0 + (S/x_0));
            //printf("x1: %lf\n",x_1);


        }

        output[i] = x_1;
    }
}




