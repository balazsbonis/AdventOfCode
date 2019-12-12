library handy_utils;

class MathUtils {
  static int greatestCommonDivisor(int a, int b) {
    if (a == 0 || b == 0) return 0; // technically should throw exception here
    int remainder = 0;
    do {
      remainder = a % b;
      a = b;
      b = remainder;
    } while (b != 0);
    return a;
  }
}
