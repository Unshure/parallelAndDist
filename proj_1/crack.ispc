
int32 map(int32 convert){
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

export void crack(uniform size_t h_pass, uniform int powers[], uniform size_t possibleLen, uniform int32 setSize) {

  // Loop through len 1 - possible len
  foreach ( currLen = 1 ... possibleLen + 1) {
  // Loop for all possible combinations
    for (uniform int currChar = 0; currChar <= (powers[currLen - 1] * setSize ); ++currChar) {
      //print("currlen: %\n", programIndex);
      int8 guess[5];
      size_t h_guess;
      // Set guess
      for (uniform int guessIndex = 0; guessIndex < currLen; ++guessIndex) {
        int8 temp = map((currChar / powers[guessIndex]) % setSize);
        guess[guessIndex] = temp;
      }

      // Check if it compares
      h_guess = RSHash(guess, currLen);
      if (h_pass == h_guess) {

        print("MATCH FOUND: currlen: %\t %\n",currLen, currChar);
      }
    }
  }
}