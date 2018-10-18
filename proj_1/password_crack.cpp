#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <iostream>
#include <math.h>
#include <ctime>
#include <unistd.h>

// Include the header file that the ispc compiler generates
#include "crack_ispc.h"
using namespace ispc;
using namespace std;


char map(int convert){
  if (convert < 10) {
    return (char) convert + 48;
  } else {
    return (char) convert + 87;
  }
}

unsigned int RSHash(const char* str, size_t s)
{
    unsigned int b    = 378551;
    unsigned int a    = 63689;
    unsigned int hash = 0;

    for(size_t i = 0; i < s; i++)
    {
        hash = hash * a + str[i];
        a    = a * b;
    }

    return (hash & 0x7FFFFFFF);
 }


int main() {

    //Create a file

    char password[] = "bv3q5";

    const int possibleLen = 5;

    size_t h_pass = RSHash(password, possibleLen);

    //Set size is 36 characters and one blank character
    const int setSize = 36;

    //Create array of powers of setsize
    //Used later for setting guess characters
    int powers[possibleLen];
    powers[0] = 1;
    for (int i = 1; i < possibleLen; ++i) {
      powers[i] = powers[i - 1] * setSize;
    }

    printf("-Starting Non-Parallel Password Cracker-\n");

    // Start Timer
    std:: clock_t start;
    double duration;
    start = std::clock();

    // Loop through len 1 - possible len
    for (int currLen = 1; currLen <= possibleLen; ++currLen) {
    // Loop for all possible combinations
      for (int currChar = 0; currChar <= (powers[currLen - 1] * setSize ); ++currChar) {
        char guess[5];
        size_t h_guess;
        // Set guess
        for (int guessIndex = 0; guessIndex < currLen; ++guessIndex) {
          char temp = map((currChar / powers[guessIndex]) % setSize);
          guess[guessIndex] = temp;
        }

        //printf("Iteration: %d\tGuess: %s\n", currChar, guess);

        // Check if it compares
        h_guess = RSHash(guess, currLen);
        if (h_pass == h_guess) {
          printf("Match Found Single!! \nLen: %d\tIteration: %d\tGuess: %s\n",currLen, currChar, guess);
          //break;
        }
      }
    }
    duration = ( std::clock() - start ) / (double) CLOCKS_PER_SEC;
    printf("Time: %f\n", duration);

    
    printf("-Starting Parallel Password Cracker-\n");

    start = std::clock();

    crack(h_pass, powers, possibleLen, setSize);

    duration = ( std::clock() - start ) / (double) CLOCKS_PER_SEC;
    printf("Time: %f\n", duration);

    
    return 0;
}

