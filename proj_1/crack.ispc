
int map(int convert){
  if (convert < 10) {
    return convert + 48;
  } else {
    return convert + 87;
  }
}

export void crack(uniform float vin[], uniform int count) {
    foreach (index = 0 ... count) {
        // Load the appropriate input value for this program instance.
        vin[index] = map(index);
    }
}