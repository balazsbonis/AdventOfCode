import 'dart:io';
import 'dart:math';
import '../base/data_structures.dart';
import '../base/handy_utils.dart';

class Puzzle {
  var inputFile = new File(".\\10\\input.txt");
  List<String> input = new List<String>();
  dynamic solution1;
  dynamic solution2;

  Puzzle() {}

  MeshGrid angleGrid;
  MeshGrid distanceGrid;
  MeshGrid orderGrid;
  int asteroidCount = 0;

  List<String> parseInputByLine() {
    return input = inputFile.readAsStringSync().trim().split("\n");
  }

  List<String> parseInputBySeparator({String separator = ","}) {
    return input = inputFile.readAsStringSync().trim().split(separator);
  }

  MeshGrid parseInputFile() {
    parseInputByLine();
    var grid = new MeshGrid(input[0].length, input.length);
    for (var i = 0; i < input.length; i++) {
      for (var j = 0; j < input[i].length; j++) {
        grid[i][j] = input[i][j] == "#" ? 2 : 0;
      }
    }
    return grid;
  }

  void parseInputWithAngles(int pX, int pY) {
    parseInputByLine();
    angleGrid = new MeshGrid(input[0].length, input.length, double.nan);
    distanceGrid = new MeshGrid(input[0].length, input.length, 0);
    for (var i = 0; i < input.length; i++) {
      for (var j = 0; j < input[i].length; j++) {
        if (input[i][j] == "#") {
          // calculate angle
          angleGrid[i][j] = (atan2(pX - i, pY - j) * 180 / pi);
          // calculate Manhattan distance
          distanceGrid[i][j] = (pX - i).abs() + (pY - j).abs();
          asteroidCount++;
        }
      }
    }
  }

  int countAsteroids(MeshGrid grid, int pX, int pY) {
    // 0 = not visited    empty
    // 1 = visited        empty
    // 2 = not visited    asteroid
    // 3 = visited        asteroid
    // 4 = invalidated    asteroid
    // 99 - STATION
    var asteroidCount = 0;
    grid[pX][pY] = 99;
    // fill it in
    for (int i = 0; i < grid.width; i++) {
      for (int j = 0; j < grid.height; j++) {
        if (grid[i][j] == 0 || grid[i][j] == 2) {
          //print(grid);
          var d = MathUtils.greatestCommonDivisor((i - pX).abs(), (j - pY).abs());
          var stepX = d != 0 ? (pX - i) ~/ d : (pX - i) == 0 ? 0 : 1;
          var stepY = d != 0 ? (pY - j) ~/ d : (pY - j) == 0 ? 0 : 1;
          bool halt = false;
          int checkX = i;
          int checkY = j;
          int asteroidX = -1;
          int asteroidY = -1;
          while (!halt) {
            // check boundary
            if (checkX < 0 ||
                checkY < 0 ||
                checkX >= grid.width ||
                checkY >= grid.height) {
              halt = true;
            } else {
              // check for station
              if (grid[checkX][checkY] == 99) {
                // we're in a station
                // asteroids on the other side of the station can count as a new one
                asteroidX = -1;
                asteroidY = -1;
              } else {
                // check for asteroid
                if (grid[checkX][checkY] == 2) {
                  if (asteroidX == -1 && asteroidY == -1) {
                    // haven't found an asteroid yet
                    asteroidCount++;
                    grid[checkX][checkY] = 3;
                    asteroidX = checkX;
                    asteroidY = checkY;
                  } else {
                    grid[checkX][checkY] = 4;
                  }
                } else if (grid[checkX][checkY] == 3 &&
                    asteroidX != -1 &&
                    asteroidY != -1) {
                  // found an asteroid on the line before
                  if ((pX - checkX).abs() + (pY - checkY).abs() <
                      (pX - asteroidX).abs() + (pY - asteroidY).abs()) {
                    grid[asteroidX][asteroidY] =
                        4; // invalidate the old found asteroid
                    asteroidCount--;
                    asteroidX = checkX;
                    asteroidY = checkY;
                  }
                } else if (grid[checkX][checkY] == 0) {
                  grid[checkX][checkY] = 1;
                }
                //print(grid);
                //print("x: $checkX y: $checkY count: $asteroidCount");
              }
              checkX += stepX;
              checkY += stepY;
            }
          }
        }
      }
    }
    //print(grid);
    //print(asteroidCount);
    return asteroidCount;
  }

  void solveTest() {
    var grid = new MeshGrid(5, 5, 0);
    var pX = 0;
    var pY = 4;
    grid[4][4] = 2;
    grid[2][0] = 2;
    grid[2][1] = 2;
    grid[2][2] = 2;
    grid[2][3] = 2;
    grid[2][4] = 2;
    grid[3][1] = 2;
    grid[0][4] = 2;
    grid[0][1] = 2;
    countAsteroids(grid, pX, pY);
  }

  void solvePart1() {
    var grid = parseInputFile();
    var bestX = 0, bestY = 0, bestFitness = 0;
    for (int i = 0; i < grid.width; i++) {
      for (int j = 0; j < grid.height; j++) {
        if (grid[i][j] == 2) {
          var counterGrid =
              parseInputFile(); // ugh. Can't easily clone an object in dart...
          var asteroidCount = countAsteroids(counterGrid, i, j);
          if (asteroidCount > bestFitness) {
            bestFitness = asteroidCount;
            bestX = i;
            bestY = j;
          }
        }
      }
    }
    solution1 = "($bestX, $bestY): $bestFitness"; // 385 - x - too high
    // 344 @ 34, 30
  }

  void solvePart2() {
    parseInputWithAngles(34, 30);
    print(angleGrid);
    print(distanceGrid);
    // upwards is 90.0
    // first go from 90 -> 180
    // then -180 -> 90
    num degree = 90.0;
    orderGrid = new MeshGrid(angleGrid.width, angleGrid.height);

    fillOrderGrid(degree);

    for (int i = 0; i < angleGrid.width; i++) {
      for (int j = 0; j < angleGrid.height; j++) {
        if (orderGrid[i][j] == 200) {
          print("$j $i"); // 3227 too high
        }
      }
    }

    print(orderGrid);
  }

  void fillOrderGrid(num degree) {
    int order = 1;
    while (order <= 200) {
      int bestX = -1, bestY = -1, bestD = 10000;
      for (int i = 0; i < angleGrid.width; i++) {
        for (int j = 0; j < angleGrid.height; j++) {
          if (!angleGrid[i][j].isNaN &&
              angleGrid[i][j] == degree &&
              distanceGrid[i][j] < bestD) {
            bestX = i;
            bestY = j;
            bestD = distanceGrid[i][j];
          }
        }
      }
      orderGrid[bestX][bestY] = order;
      angleGrid[bestX][bestY] = double.nan;
      distanceGrid[bestX][bestY] = 0;
      order++;

      // find next degree
      if (degree == 180.0) {
        degree = -180.0;
      }
      var min = 10000.0;
      num currentDelta = 10000.0;
      for (int i = 0; i < angleGrid.width; i++) {
        for (int j = 0; j < angleGrid.height; j++) {
          if (!angleGrid[i][j].isNaN &&
              angleGrid[i][j] > degree &&
              (angleGrid[i][j] - degree).abs() < currentDelta) {
            currentDelta = (angleGrid[i][j] - degree).abs();
            min = angleGrid[i][j];
          }
        }
      }
      degree = min;
    }
  }
}

void main() {
  Puzzle puzzle = new Puzzle();

  Stopwatch stopwatch = new Stopwatch();
  stopwatch.start();
  //puzzle.solveTest();
  //puzzle.solvePart1();
  puzzle.solvePart2();
  stopwatch.stop();

  print("Solution to part1: ${puzzle.solution1}");
  print("Solution to part2: ${puzzle.solution2}");
  print("Execution took ${stopwatch.elapsed}");
}
