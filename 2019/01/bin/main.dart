import 'dart:convert';
import 'dart:io';
import 'dart:async';

void main(){
  final inputFile = new File("01\\bin\\input.txt");
  Stream<List<int>> inputStream = inputFile.openRead();

  int fuel = 0;
  inputStream
    .transform(utf8.decoder)
    .transform(new LineSplitter())
    .listen((String line){
      var mass = int.parse(line);
      fuel += part2(mass);  // pt 1.
    },
    onDone: () {
      print("Fuel: ${fuel}");
    },
    onError: (e) {print(e.toString());});
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