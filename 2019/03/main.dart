import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:image/image.dart';

class Puzzle {
  final inputFile = new File(".\\03\\input.txt");
  List<String> input = new List<String>();

  Puzzle() {}

  List<String> parseInputByLine() {
    return input = inputFile.readAsStringSync().trim().split("\n");
  }

  List<String> parseInputBySeparator({String separator = ","}) {
    return input = inputFile.readAsStringSync().trim().split(separator);
  }
}

class Point2D {
  int x;
  int y;
  int tag;

  Point2D(this.x, this.y, {this.tag});

  int manhattanDistanceFrom(int otherX, int otherY) {
    var xDiff = otherX - x;
    if (xDiff < 0) xDiff = -xDiff;
    var yDiff = otherY - y;
    if (yDiff < 0) yDiff = -yDiff;
    return xDiff + yDiff;
  }
}

class Matrix {
  List<List<int>> matrix;

  Matrix(int size) {
    matrix = new List<List<int>>(size);
    for (int i = 0; i < matrix.length; i++) {
      matrix[i] = new List<int>(size);
      for (int j = 0; j < matrix.length; j++) {
        matrix[i][j] = 0;
      }
    }
  }
}

void main() {
  Puzzle puzzle = new Puzzle();

  // pt1
  //doThePuzzle(puzzle);

  // pt2
  drawThePuzzle(puzzle);
}

void doThePuzzle(Puzzle puzzle) {
  var wireStrings = puzzle.parseInputByLine();
  var matrices = new List<Matrix>(wireStrings.length);
  var crossings = List<Point2D>();

  for (int i = 0; i < wireStrings.length; i++) {
    matrices[i] = new Matrix(20000);
    var matrix = matrices[i].matrix;
    var paths = wireStrings[i].split(",");
    var currentX = 10000;
    var currentY = 10000;
    var wireLengthSoFar = 0;
    for (String j in paths) {
      var sectionLength = int.parse(j.substring(1));
      switch (j[0]) {
        case "U":
          for (int y = currentY; y > currentY - sectionLength; y--) {
            if (i > 0 && matrices[0].matrix[currentX][y] != 0) {
              var otherWireLength = matrices
                  .firstWhere((s) => s.matrix[currentX][y] != 0)
                  .matrix[currentX][y];
              crossings.add(new Point2D(currentX, y,
                  tag: otherWireLength + wireLengthSoFar));
            }
            matrix[currentX][y] = ++wireLengthSoFar;
          }
          currentY = currentY - sectionLength;
          break;
        case "D":
          for (int y = currentY; y < currentY + sectionLength; y++) {
            if (i > 0 && matrices[0].matrix[currentX][y] != 0) {
              var otherWireLength = matrices
                  .firstWhere((s) => s.matrix[currentX][y] != 0)
                  .matrix[currentX][y];
              crossings.add(new Point2D(currentX, y,
                  tag: otherWireLength + wireLengthSoFar));
            }
            matrix[currentX][y] = ++wireLengthSoFar;
          }
          currentY = currentY + sectionLength;
          break;
        case "L":
          for (int x = currentX; x > currentX - sectionLength; x--) {
            if (i > 0 && matrices[0].matrix[x][currentY] != 0) {
              var otherWireLength = matrices
                  .firstWhere((s) => s.matrix[x][currentY] != 0)
                  .matrix[x][currentY];
              crossings.add(new Point2D(x, currentY,
                  tag: otherWireLength + wireLengthSoFar));
            }
            matrix[x][currentY] = ++wireLengthSoFar;
          }
          currentX = currentX - sectionLength;
          break;
        case "R":
          for (int x = currentX; x < currentX + sectionLength; x++) {
            if (i > 0 && matrices[0].matrix[x][currentY] != 0) {
              var otherWireLength = matrices
                  .firstWhere((s) => s.matrix[x][currentY] != 0)
                  .matrix[x][currentY];
              crossings.add(new Point2D(x, currentY,
                  tag: otherWireLength + wireLengthSoFar));
            }
            matrix[x][currentY] = ++wireLengthSoFar;
          }
          currentX = currentX + sectionLength;
          break;
      }
    }
  }
  print("Crossings: ");
  for (Point2D c in crossings) {
    print(
        "${c.x},${c.y} - distance: ${c.manhattanDistanceFrom(10000, 10000)} - wireLength: ${c.tag - 1}");
  }
}

void drawThePuzzle(Puzzle puzzle) {
  var wireStrings = puzzle.parseInputByLine();
  var random = Random();
  Image image = Image(20000, 20000);
  fill(image, getColor(0, 0, 0));

  for (int i = 0; i < wireStrings.length; i++) {
    var lineColour = getColor(random.nextInt(155) + 100,
        random.nextInt(155) + 100, random.nextInt(155) + 100);
    var currentX = 10000;
    var currentY = 10000;
    var paths = wireStrings[i].split(",");
    for (String j in paths) {
      var sectionLength = int.parse(j.substring(1));
      switch (j[0]) {
        case "U":
          drawLine(image, currentX, currentY, currentX,
              currentY - sectionLength, lineColour,
              thickness: 5);
          currentY = currentY - sectionLength;
          break;
        case "D":
          drawLine(image, currentX, currentY, currentX,
              currentY + sectionLength, lineColour,
              thickness: 5);
          currentY = currentY + sectionLength;
          break;
        case "L":
          drawLine(image, currentX, currentY, currentX - sectionLength,
              currentY, lineColour,
              thickness: 5);
          currentX = currentX - sectionLength;
          break;
        case "R":
          drawLine(image, currentX, currentY, currentX + sectionLength,
              currentY, lineColour,
              thickness: 5);
          currentX = currentX + sectionLength;
          break;
      }
    }
  }
  File('output.png').writeAsBytesSync(encodePng(image));
}
