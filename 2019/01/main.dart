import 'dart:io';

void main(){
  // Pt 1.
  int fuel = 0;
  new File("01\\input.txt").readAsStringSync().trim().split("\n").forEach((f) => {
    fuel += part1(int.parse(f))
  });
  print(fuel);

  // Pt 2.
  fuel = 0;
  new File("01\\input.txt").readAsStringSync().trim().split("\n").forEach((f) => {
    fuel += part2(int.parse(f))
  });
  print(fuel);
}

// pt. 1
int part1(int mass){
  return (mass ~/ 3) - 2;
}

// pt. 2
int part2(int mass){
  int fuel = 0;
  int difference = 0;
  do {
    difference = (mass ~/ 3) - 2;
    if (difference >= 0) {
      fuel += difference;
      mass = difference;
    }
  }
  while (difference > 0);
  return fuel;
}