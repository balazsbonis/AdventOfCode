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

extension Linq on Iterable {
  sum([fn(x)]) => this.fold(
      0, (prev, element) => prev + (fn != null ? fn(element) : element));

  min() => this.fold(double.maxFinite,
      (prev, element) => prev.compareTo(element) > 0 ? element : prev);

  max() => this.fold(double.minPositive,
      (prev, element) => prev.compareTo(element) > 0 ? prev : element);

  average() => sum() / this.length;
}
