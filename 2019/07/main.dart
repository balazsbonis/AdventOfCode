import 'dart:io';
import 'package:trotter/trotter.dart';

import '../base/intcode_compiler.dart';

class Puzzle {
  final inputFile = new File(".\\07\\input.txt");
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

  void solve() {
    var memory =
        parseInputBySeparator().map((String s) => int.parse(s)).toList();
    var phases = characters("01234");
    var permutations = Permutations(5, phases);

    var solutions = new Map<String, int>();
    for (var perm in permutations()) {
      var inputParameter = 0;
      for (int i = 0; i < 5; i++) {
        var run = new Runner(memory, [int.parse(perm[i]), inputParameter]);
        run.run();
        inputParameter = run.lastOutput;
      }
      solutions[perm.toString()] = inputParameter;
    }

    // get MAX:
    solution1 = solutions.values.fold(double.minPositive,
        (prev, elem) => prev > elem ? prev : elem);
  }
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
