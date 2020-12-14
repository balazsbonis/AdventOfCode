import 'dart:io';
import '../base/handy_utils.dart';

void main() {
  //var times = ["7", "13", "x", "x", "59", "x", "31", "19"];
  var inputFile = new File("c:\\Work\\Code\\AdventOfCode\\2020\\13\\input.txt");
  var times = inputFile.readAsStringSync().trim().split(",");
  int t = 0;
  int increment = int.parse(times[0]);
  int offset = 1;
  while (offset < times.length) {
    if (times[offset] == "x") {
      offset++;
      continue;
    }
    t += increment;
    var current = int.parse(times[offset]);
    if ((t + offset) % current != 0) {
      continue;
    }
    increment *= current;
    offset++;
  }
  print(times);
  print(t);
}
