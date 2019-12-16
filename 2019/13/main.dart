import 'dart:io';

import '../base/intcode_compiler.dart';

class Puzzle {
  final inputFile = new File(".\\13\\input.txt");
  List<String> input = new List<String>();
  dynamic solution1;
  dynamic solution2;

  Map screen = new Map();
  int curOutType = 0; // 0 = x, 1 = y, 2 = object
  int curX, curY;

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

    var params = [0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    memory[0] = 2;
    new Runner(memory, params)
      ..reset()
      ..setOutputCallback((res) => paintScreen(res))
      ..run();

    //printScreen();
    //screen.removeWhere((k,v) => v != 2);
    //solution1 = screen.length; //320
  }

  void solveTest() {}

  void paintScreen(res) {
    switch (curOutType) {
      case 0:
        curX = res;
        break;
      case 1:
        curY = res;
        break;
      default:
        screen["$curX,$curY"] = res;
        break;
    }

    curOutType++;
    if (curOutType == 3) {
      curOutType = 0;
    }
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
