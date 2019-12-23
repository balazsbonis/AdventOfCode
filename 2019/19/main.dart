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
    solution1 = counter; //126

    // ---=== PART 2 ===---

    // Based on the description to multiply by 10000, I assume the results will be larger than 1000...
    int currentRow = 1000, currentColumn = 1000;
    bool foundSquare = false;
    bool foundFirstBeamInRow, foundLastBeamInRow;

    while (!foundSquare) {
      foundFirstBeamInRow = false;
      foundLastBeamInRow = false;
      while (!foundFirstBeamInRow) {
        // first find the first place where it says 1. The first two lines will crash, because they have only 1 or 0 of spots in the beam
        params = [currentRow, currentColumn];
        var r1 = new Runner(memory, params)
          ..reset()
          ..run();
        if (r1.lastOutput == 0) {
          currentColumn++;
        } else {
          foundFirstBeamInRow = true;
        }
      }
      // check whether the beam is 100 wide first
      int rightMostPoint = currentColumn + 99;
      params = [currentRow, rightMostPoint];
      var r2 = new Runner(memory, params)
        ..reset()
        ..run();
      if (r2.lastOutput == 0) {
        currentRow++;
      } else {
        // the beam is 100 wide, find the rightmost point
        while (!foundLastBeamInRow) {
          rightMostPoint++;
          params = [currentRow, rightMostPoint];
          var r3 = new Runner(memory, params)
            ..reset()
            ..run();
          if (r3.lastOutput == 0) {
            foundLastBeamInRow = true;
            rightMostPoint--;
          }
        }
        // found the rightmost point, now check whether [currentRow + 99][rightmost - 99] is 1 - do we have a square there
        params = [currentRow + 99, rightMostPoint - 99];
        var r4 = new Runner(memory, params)
          ..reset()
          ..run();
        if (r4.lastOutput == 1) {
          foundSquare = true;
          solution2 = currentRow * 10000 + (rightMostPoint - 99);
          // 11351625
        } else {
          // not a square, move along
          currentRow++;
        }
      }
    }
  }

  calculateResult(int res) {
    if (res == 1) {
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
