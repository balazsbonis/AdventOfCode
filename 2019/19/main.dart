import 'dart:io';
import '../base/intcode_compiler.dart';

class Puzzle {
  final inputFile = new File(".\\19\\input.txt");
  List<String> input = new List<String>();
  dynamic solution1;
  dynamic solution2;
  List<int> params;
  int counter = 0;

  Puzzle() {}

  List<String> parseInputByLine() {
    return input = inputFile.readAsStringSync().trim().split("\n");
  }

  List<String> parseInputBySeparator({String separator = ","}) {
    return input = inputFile.readAsStringSync().trim().split(separator);
  }

  void solve() {
    var memory =
        parseInputBySeparator().map((String s) => int.parse(s)).toList();

    for (int curX = 0; curX < 50; curX++)
      for (int curY = 0; curY < 50; curY++) {
        params = [curX, curY];
        new Runner(memory, params)
          ..reset()
          ..setOutputCallback((res) => calculateResult(res))
          ..run();
      }
    solution1 = counter;
  }

  calculateResult(int res) {
    if (res == 1){
      counter++;
    }
  }

  void solveTest() {}
}

void main() {
  Puzzle puzzle = new Puzzle();

  Stopwatch stopwatch = new Stopwatch();
  stopwatch.start();
  puzzle.solve();
  stopwatch.stop();

  print("Solution to part1: ${puzzle.solution1}");
  print("Solution to part2: ${puzzle.solution2}");
  print("Execution took ${stopwatch.elapsed}");
}
