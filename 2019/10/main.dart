import 'dart:io';
import '../base/meshgrid.dart';

class Puzzle {
  final inputFile = new File(".\\10\\input.txt");
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

  int leastCommonMultiple(int a, int b) {
    if (a == 0 || b == 0) return 0;
    return (a * b) ~/ greatestCommonDivisor(a, b);
  }

  int greatestCommonDivisor(int a, int b) {
    if (a == 0 || b == 0) return 0; // technically should throw exception here
    int remainder = 0;
    do {
      remainder = a % b;
      a = b;
      b = remainder;
    } while (b != 0);
    return a;
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

  int countAsteroids(MeshGrid grid, int pX, int pY) {
    // 0 = not visited    empty
    // 1 = visited        empty
    // 2 = not visited    asteroid
    // 3 = visited        asteroid
    // 4 = invalidated    asteroid
    // 99 - STATION
    var asteroidCount = 0;

    // fill it in
    for (int i = 0; i < grid.width; i++) {
      for (int j = 0; j < grid.height; j++) {
        if (grid[i][j] == 0 || grid[i][j] == 2) {
          var d = greatestCommonDivisor((i - pX).abs(), (j - pY).abs());
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
                  } else {
                    // found an asteroid on the line before
                    grid[asteroidX][asteroidY] = 4; // invalidate the asteroid
                  }
                  asteroidX = checkX;
                  asteroidY = checkY;
                  grid[checkX][checkY] = 3;
                } else if (grid[checkX][checkY] == 0) {
                  grid[checkX][checkY] = 1;
                }
                //print(grid.toString());
                //print("x: $checkX y: $checkY count: $asteroidCount");
              }
              checkX += stepX;
              checkY += stepY;
            }
          }
        }
      }
    }

    //print(asteroidCount);
    return asteroidCount;
  }

  void solveTest() {
    var grid = new MeshGrid(5, 5, 0);
    var pX = 4;
    var pY = 3;
    grid[pX][pY] = 99;
    grid[4][4] = 2;
    grid[2][0] = 2;
    grid[2][1] = 2;
    grid[2][2] = 2;
    grid[2][3] = 2;
    grid[2][4] = 2;
    grid[3][4] = 2;
    grid[0][4] = 2;
    grid[0][1] = 2;
    countAsteroids(grid, pX, pY);
  }

  void solve() {
    var grid = parseInputFile();
    var bestX = 0, bestY = 0, bestFitness = 0;
    for (int i = 0; i < grid.width; i++) {
      for (int j = 0; j < grid.height; j++) {
        if (grid[i][j] == 2) {
          var counterGrid = parseInputFile(); // ugh. Can't easily clone an object in dart...
          var asteroidCount = countAsteroids(counterGrid, i, j);
          if (asteroidCount > bestFitness){
            bestFitness = asteroidCount;
            bestX = i;
            bestY= j;
          }

        }
      }
    }
    solution1 = "($bestX, $bestY): $bestFitness"; // 385 - x - too high
  }
}

void main() {
  Puzzle puzzle = new Puzzle();

  Stopwatch stopwatch = new Stopwatch();
  stopwatch.start();
  //puzzle.solveTest();
  puzzle.solve();
  stopwatch.stop();

  print("Solution to part1: ${puzzle.solution1}");
  print("Solution to part2: ${puzzle.solution2}");
  print("Execution took ${stopwatch.elapsed}");
}
