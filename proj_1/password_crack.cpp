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

int main() {

    string password = "bv37q";

    int possibleLen = password.size();
    //Set size is 36 characters and one blank character
    int setSize = 36;

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

    // Loop for all possible combinations
    for (int currChar = 0; currChar <= (powers[possibleLen - 1] * setSize); ++currChar) {
      string guess;
      // Set guess
      for (int guessIndex = 0; guessIndex < possibleLen; ++guessIndex) {
        char temp = map((currChar / powers[guessIndex]) % setSize);
        guess.append(1, temp);
        if (temp == '\0') {
          break;
        }
      }

      //printf("Iteration: %d\tGuess: %s\n", currChar, guess.c_str());

      // Check if it compares
      string check(guess);
      if (password.compare(check) == 0) {
        //printf("Cracked in %d guesses\n", currChar);
        break;
      }
    }

    duration = ( std::clock() - start ) / (double) CLOCKS_PER_SEC;
    printf("Time: %f\n", duration);



    return 0;
}

