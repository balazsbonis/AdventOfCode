import 'dart:io';
import 'package:image/image.dart';

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
  int oxygenX = 0, oxygenY = 0;

  GifEncoder encoder = new GifEncoder(repeat: 1);
  Image image = Image(500, 500);

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
    fill(image, getColor(0, 0, 0));
    encoder.addFrame(image, duration: 3);

    new Runner(memory, params)
      ..reset()
      ..setOutputCallback((res) => findOxygen(res))
      ..run();
    File('output15.gif').writeAsBytesSync(encoder.finish());
  }

  findOxygen(int res) {
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
      case 2:
        // empty space, moved there
        if (!screen.containsKey("$actX,$actY")) {
          screen["$actX,$actY"] = ++curStep;
          moves.add(curDirection);
        } else {
          curStep = screen["$actX,$actY"];
        }
        curX = actX;
        curY = actY;
        //found tha thing
        if (res == 2) {
          oxygenX = curX;
          oxygenY = curY;
          solution1 = curStep;
          fillRect(
              image,
              (250 - curX * 10),
              (250 - curY * 10),
              250 - ((curX + 1) * 10 - 1),
              250 - ((curY + 1) * 10 - 1),
              getColor(0, 255, 255));
        }
        break;
      default:
    }
    fillRect(
        image,
        (250 - curX * 10),
        (250 - curY * 10),
        250 - ((curX + 1) * 10 - 1),
        250 - ((curY + 1) * 10 - 1),
        getColor(255, 160, 160));
    encoder.addFrame(image, duration: 3);
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
      if (moves.length == 0) {
        //printScreen(screen);
        curDirection = 0;
        calculateSolution2();
      } else {
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
    params.add(curDirection);
  }

  void calculateSolution2() {
    int minutes = 0;
    var fc = screen.values.where((x) => x != -1).length; // maybe -1?
    screen["$oxygenX,$oxygenY"] = 0;
    var lookaround = ["$oxygenX,$oxygenY"];
    var toCheck = new List<String>();
    var visited = ["$oxygenX,$oxygenY"];

    while (visited.length != fc) {
      minutes++;
      // check neighbours for each new item
      for (var l in lookaround) {
        var coords = l.split(",");
        var x = int.parse(coords[0]);
        var y = int.parse(coords[1]);
        // northern-southern neighbours
        if (screen["$x,${y - 1}"] != -1 && !visited.contains("$x,${y - 1}"))
          toCheck.add("$x,${y - 1}");
        if (screen["$x,${y + 1}"] != -1 && !visited.contains("$x,${y + 1}"))
          toCheck.add("$x,${y + 1}");
        // eastern-western
        if (screen["${x - 1},$y"] != -1 && !visited.contains("${x - 1},$y"))
          toCheck.add("${x - 1},$y");
        if (screen["${x + 1},$y"] != -1 && !visited.contains("${x + 1},$y"))
          toCheck.add("${x + 1},$y");
      }
      lookaround.clear();
      for (var c in toCheck) {
        screen[c] = minutes;
        var coords = c.split(",");
        var x = int.parse(coords[0]);
        var y = int.parse(coords[1]);
        visited.add(c);
        fillRect(
            image,
            (250 - x * 10),
            (250 - y * 10),
            250 - ((x + 1) * 10 - 1),
            250 - ((y + 1) * 10 - 1),
            getColor(128, 128, 255));
      }
      lookaround.addAll(toCheck);
      toCheck.clear();
      //printScreen(screen);
      encoder.addFrame(image, duration: 3);
    }

    solution2 = minutes;
  } //370

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
