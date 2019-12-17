import 'dart:io';
import 'dart:math';

import 'package:image/image.dart';

import '../base/intcode_compiler.dart';

class Puzzle {
  final inputFile = new File(".\\13\\input.txt");
  List<String> input = new List<String>();
  dynamic solution1;
  dynamic solution2;

  Map screen = new Map();
  int curOutType = 0; // 0 = x, 1 = y, 2 = object
  int curX, curY;
  int ballX, ballY;
  int padX = 17, padY = 20;
  bool score = false, play = false;
  List<int> params;
  Random random = new Random();

  GifEncoder encoder = new GifEncoder(repeat: 1);
  Image image = Image(380, 200);

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

    params = [0];
    memory[0] = 2;

    fill(image, getColor(0, 0, 0));
    encoder.addFrame(image, duration: 3);
    new Runner(memory, params)
      ..reset()
      ..setOutputCallback((res) => paintScreen(res))
      ..run();
    File('output13.gif').writeAsBytesSync(encoder.finish());

    //printScreen();
    //screen.removeWhere((k,v) => v != 2);
    //solution1 = screen.length; //320
  }

  void solveTest() {}

  void paintScreen(res) {
    if (score && curOutType == 2) {
      solution2 = res;
      score = false;
    } else if (res == -1) {
      score = true;
      if (!play) {
        print("PLAY START");
        play = true;
        encoder.addFrame(image, duration: 3);
      }
    } else {
      switch (curOutType) {
        case 0:
          curX = res;
          break;
        case 1:
          curY = res;
          break;
        default:
          screen["$curX,$curY"] = res;
          int color;
          switch (res) {
            case 0:
              color = getColor(0, 0, 0);
              break;
            case 1:
              color = getColor(255, 255, 255);
              break;
            case 2:
              color = getColor(255, 0, 0);
              break;
            case 3:
              color = getColor(50, 255, 50);
              padX = curX;
              padY = curY;
              break;
            case 4:
              color = getColor(0, 128, 255);
              ballX = curX;
              ballY = curY;
              if (ballX > padX) params.add(1);
              else if (padX > ballX) params.add(-1);
              break;
          }
          fillRect(image, curX * 10, curY * 10, ((curX + 1) * 10 - 1),
              ((curY + 1) * 10 - 1), color);
          if (play && res != 0) {
            encoder.addFrame(image, duration: 3);
          }
          break;
      }
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
