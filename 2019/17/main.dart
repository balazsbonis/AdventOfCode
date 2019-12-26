import 'dart:convert';
import 'dart:io';
import '../base/intcode_compiler.dart';
import '../base/data_structures.dart';

class Puzzle {
  final inputFile = new File(".\\17\\input.txt");
  List<String> input = new List<String>();
  dynamic solution1;
  dynamic solution2;
  List<int> params;
  MeshGrid meshgrid;
  int curX = 0, curY = 0;

  Puzzle() {
    meshgrid = new MeshGrid(41, 51);
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
    params = [];

    new Runner(memory, params)
      ..reset()
      ..setOutputCallback((res) => buildPicture(res))
      ..run();

    solution1 = 0;
    for (int i = 1; i < meshgrid.width - 1; i++) {
      for (int j = 1; j < meshgrid.height - 1; j++) {
        if (meshgrid[i][j] == 35 &&
            meshgrid[i - 1][j] == 35 &&
            meshgrid[i + 1][j] == 35 &&
            meshgrid[i][j - 1] == 35 &&
            meshgrid[i][j + 1] == 35) {
          meshgrid[i][j] = 79;
          solution1 += i * j;
        }
      }
    }

//C B C A B A C A B A
// A = L,4 L,6 L,8 L,8
// B = R,10 L,8 L,8 L,10
// C = L,8 R,10, L,10
    print(meshgrid.toASCIIString());

    memory[0] = 2;
    var ascii = AsciiCodec();
    params = ascii.encode("C,B,C,A,B,A,C,A,B,A\n");
    params += ascii.encode("L,4,L,6,L,8,L,8\n");
    params += ascii.encode("R,10,L,8,L,8,L,10\n");
    params += ascii.encode("L,8,R,10,L,10\n");
    params += ascii.encode("n\n");

    print(params);

    var run = new Runner(memory, params)
      ..reset()
      ..run();
    solution2 = run.lastOutput;
  }

  void buildPicture(int res) {
    if (res == 10) {
      curX++;
      curY = 0;
    } else {
      meshgrid[curX][curY] = res;
      curY++;
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
