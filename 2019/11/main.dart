import 'dart:io';
import 'package:image/image.dart';

import '../base/intcode_compiler.dart';

class Puzzle {
  final inputFile = new File(".\\11\\input.txt");
  List<String> input = new List<String>();
  dynamic solution1;
  dynamic solution2;
  List<int> params = [1]; // set to 0 for part 1, 1 for part 2
  var posX = 0;
  var posY = 0;
  bool modeBit = false; // false = color, true = direction
  String direction = "U";
  Map hull = new Map();

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

    hull["$posX,$posY"] = 0;
    new Runner(memory, params)
      ..reset()
      ..setOutputCallback((res) => paintHull(res))
      ..run();
    solution1 = hull.length;

    paintHullToFile();
  }

  void paintHull(int result) {
    if (!modeBit) {
      // paint
      hull["$posX,$posY"] = result;
    } else {
      // direction
      if (result == 0) {
        // left
        switch (direction) {
          case "U":
            direction = "L";
            break;
          case "L":
            direction = "D";
            break;
          case "D":
            direction = "R";
            break;
          case "R":
            direction = "U";
            break;
        }
      } else {
        // right
        switch (direction) {
          case "U":
            direction = "R";
            break;
          case "R":
            direction = "D";
            break;
          case "D":
            direction = "L";
            break;
          case "L":
            direction = "U";
            break;
        }
      }
      moveRobot();
      params.add(hull["$posX,$posY"]);
    }
    modeBit = !modeBit;
    print("$posX,$posY");
  }

  void solveTest() {}

  void moveRobot() {
    switch (direction) {
      case "U":
        posY++;
        break;
      case "R":
        posX++;
        break;
      case "D":
        posY--;
        break;
      case "L":
        posX--;
        break;
    }
    if (!hull.containsKey("$posX,$posY")) {
      hull["$posX,$posY"] = 0;
    } else {
      print("BEEN HERE $posX,$posY");
    }
  }

  void paintHullToFile() {
    Image image = Image(200, 200);
    fill(image, getColor(0, 0, 0));
    hull.forEach((k, v) => putPixel(image, k, v));
    File('output11.png').writeAsBytesSync(encodePng(image));
  }

  putPixel(Image image, k, v) {
    if (v.toString() == "1") {
      var coords = k.toString().split(",").map((n) => int.parse(n)).toList();
      drawPixel(image, 100-coords[0], 100-coords[1], getColor(255,255,255));
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
