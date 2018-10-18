
int8 map(int8 convert){
  if (convert < 10) {
    return convert + 48;
  } else {
    return convert + 87;
  }
}


unsigned int RSHash(varying int8 str[], size_t s)
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

export void crack(uniform size_t h_pass, 
                  uniform size_t possibleLen, 
                  uniform int setSize) {

  // Loop through len 1 - possible len
  foreach ( currLen = 1 ... 6) {
    print("parallel: %\n", currLen);
  // Loop for all possible combinations
    int8 guess[5];
    size_t h_guess;

    for (uniform int currChar = 0; currChar <= pow((float)setSize, currLen); ++currChar) {
      //print("currlen: %\n", programIndex);
      // Set guess
      for (uniform int guessIndex = 0; guessIndex < currLen; ++guessIndex) {
        guess[guessIndex] = map((currChar / (int) pow((float) setSize, (float) guessIndex)) % setSize);
      }

      // Check if it compares
      h_guess = RSHash(guess, currLen);
      if (h_pass == h_guess) {

        print("MATCH FOUND: currlen: %\t %\n",currLen, currChar);
      }
    }
  }
}



task void crack_task(uniform int range, 
                      uniform size_t h_pass,
                      uniform int powers[],
                      uniform size_t possibleLen,
                      uniform int setSize) {


  uniform int start = taskIndex * range;

  uniform int stop = min(powers[possibleLen - 1] * setSize, start + range);

  foreach(i = start ... stop) {


  }




}