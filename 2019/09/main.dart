import 'dart:io';

import 'intcode_compiler.dart';

class Puzzle {
  final inputFile = new File(".\\09\\input.txt");
  List<String> input = new List<String>();
  dynamic solution1;
  dynamic solution2;

  Puzzle() {}

  List<String> parseInputByLine() {
    return input = inputFile.readAsStringSync().trim().split("\n");
  }

  List<String> parseInputBySeparator({String separator = ","}) {
    return input = inputFile.readAsStringSync().trim().split(separator);
  }

  void solveSimpleTests() {
    var memories = {
      // [1, 1, 1, 4, 99, 5, 6, 0, 99], //[30,1,1,4,2,5,6,0,99]
      // [3, 9, 8, 9, 10, 9, 4, 9, 99, -1, 8], // output should be 0
      // [3, 9, 7, 9, 10, 9, 4, 9, 99, -1, 8], // output should be 1
      // [3, 3, 1107, -1, 8, 3, 4, 3, 99], // output should be 1
      // [3,21,1008,21,8,20,1005,20,22,107,8,
      // 21,20,1006,20,31,1106,0,36,98,0,0,1002,
      // 21,125,20,4,20,1105,1,46,104,999,1105,1,
      // 46,1101,1000,1,20,4,20,1105,1,46,98,99], // output should be 999
      [109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99], // quine
      [1102,34915192,34915192,7,4,7,99,0], // 1219070632396864 
    };

    for (var memory in memories) {
      print("Running test for $memory");
      var run = new Runner(memory, [1]);//..enablePrint();
      run.run();
    }
  }

  void solve() {
    var memory =
        parseInputBySeparator().map((String s) => int.parse(s)).toList();
    var run = new Runner(memory, [1]);
      //..enablePrint(); // 203 - x - low
    run.run();
  }
}


void main() {
  Puzzle puzzle = new Puzzle();

  Stopwatch stopwatch = new Stopwatch();
  stopwatch.start();
  //puzzle.solveSimpleTests();
  puzzle.solve();
  stopwatch.stop();

  print("Solution to part1: ${puzzle.solution1}");
  print("Solution to part2: ${puzzle.solution2}");
  print("Execution took ${stopwatch.elapsed}");
}
