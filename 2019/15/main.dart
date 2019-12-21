import 'dart:io';
import '../base/intcode_compiler.dart';
import '../base/data_structures.dart';

class Puzzle {
  final inputFile = new File(".\\15\\input.txt");
  List<String> input = new List<String>();
  dynamic solution1;
  dynamic solution2;
  List<int> params;
  List<int> moves;
  Map screen = new Map();
  int curX = 0, curY = 0, curStep = 0, curDirection = 1;

  Puzzle() {
    moves = new List<int>();
  }

  List<String> parseInputByLine() {
    return input = inputFile.readAsStringSync().trim().split("\n");
  }

  List<String> parseInputBySeparator({String separator = ","}) {
    return input = inputFile.readAsStringSync().trim().split(separator);
  }

  void solve() {
    var memory =
        parseInputBySeparator().map((String s) => int.parse(s)).toList();
    params = [1]; // 1 = N, 2 = S, 3 = W, 4 = E
    screen["0,0"] = 99;
    new Runner(memory, params)
      ..reset()
      ..setOutputCallback((res) => findOxygen(res))
      ..run();
  }

  findOxygen(int res) {
    if (solution1 != null){
      return;
    }
    printScreen(screen);
    print(
        "$curX, $curY, $curDirection, ${moves.length}, ${moves.length > 0 ? moves.last : -1}");
    var actX = curX, actY = curY;
    switch (params.last) {
      case 1:
        actY--;
        break;
      case 2:
        actY++;
        break;
      case 3:
        actX--;
        break;
      case 4:
        actX++;
        break;
    }
    switch (res) {
      case 0:
        // wall
        screen["$actX,$actY"] = -1;
        break;
      case 1:
        // empty space, moved there
        if (!screen.containsKey("$actX,$actY")) {
          screen["$actX,$actY"] = ++curStep;
          moves.add(curDirection);
        } else {
          curStep = screen["$actX,$actY"];
        }
        curX = actX;
        curY = actY;
        break;
      case 2:
        //found tha thing
        solution1 = curStep + 1;
        break;
      default:
    }
    // set direction
    if (screen["${curX - 1},$curY"] == null) {
      curDirection = 3;
    } else if (screen["${curX},${curY - 1}"] == null) {
      curDirection = 1;
    } else if (screen["${curX + 1},${curY}"] == null) {
      curDirection = 4;
    } else if (screen["${curX},${curY + 1}"] == null) {
      curDirection = 2;
    } else {
      // all 4 sides explored, take 1 step back!
      if (moves.last == 1) {
        curDirection = 2;
      } else {
        if (moves.last == 2) {
          curDirection = 1;
        } else {
          if (moves.last == 4) {
            curDirection = 3;
          } else {
            if (moves.last == 3) {
              curDirection = 4;
            }
          }
        }
      }
      moves.removeLast();
    }
    params.add(curDirection);
  }

  void setDirection() {
    if (screen["${curX - 1},$curY"] == null) {
      curDirection = 3;
      moves.add(curDirection);
    } else if (screen["${curX},${curY - 1}"] == null) {
      curDirection = 1;
      moves.add(curDirection);
    } else if (screen["${curX + 1},${curY}"] == null) {
      curDirection = 4;
      moves.add(curDirection);
    } else if (screen["${curX},${curY + 1}"] == null) {
      curDirection = 2;
      moves.add(curDirection);
    } else {
      // all 4 sides explored, take 1 step back!
      if (moves.last == 1) {
        curDirection = 2;
      } else {
        if (moves.last == 2) {
          curDirection = 1;
        } else {
          if (moves.last == 4) {
            curDirection = 3;
          } else {
            if (moves.last == 3) {
              curDirection = 4;
            }
          }
        }
      }
      moves.removeLast();
    }
  }

  void printScreen(Map map) {
    var mg = MeshGrid.fromMap(map, 50, 50);
    mg[25 - curX][25 - curY] = double.nan;
    print(mg);
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
