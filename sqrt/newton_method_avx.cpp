#include <immintrin.h>  // allows us to use AVX instructions
#include <stdio.h>
#include <stdlib.h>

void newton_method_avx(int input_size,
                float x_initial,
                float input[],
                float output[])
{
    // Computes the square root of each element in the values array and stores it in the output array
    // input_size should be set to the size of the input/output array
    // x0 is the initial guess for Newton's method

    __m256 tolerance = _mm256_set1_ps(0.001f); // break tolerance is 10**-4
    __m256* avx_input = (__m256*) input; // cast our input to avx type
    __m256* avx_output = (__m256*) output;
    __m256 step1, step2, step3;  // here we make 3 avx vectors to store intermediete results
    for (int i=0; i<input_size/4; i++) { // we do 4 calculations per loop now
        __m256 x_0 = _mm256_set1_ps(x_initial);
        step1 = _mm256_mul_ps(*avx_input, x_0);
        step2 = _mm256_add_ps(x_0, step1);
        step3 = _mm256_mul_ps(step2, _mm256_set1_ps(.5f));
        __m256 x_1 = step3;


        // while (fabs(x_1-x_0) > tolerance) {
        for(int j=0; j<5; j++){
            x_0 = x_1;
            step1 = _mm256_mul_ps(*avx_input, x_0);
            step2 = _mm256_add_ps(x_0, step1);
            step3 = _mm256_mul_ps(step2, _mm256_set1_ps(.5f));
            x_1 = step3;

        }
        //printf("%d", x_1);
        avx_output = (&x_1);
        avx_input++;
        avx_output++;
    }
}