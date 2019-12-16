import 'dart:io';
import 'package:image/image.dart';

import '../base/data_structures.dart';

class Puzzle {
  final inputFile = new File(".\\08\\input.txt");
  List<String> input = new List<String>();
  dynamic solution1;
  dynamic solution2;

  List<MeshGrid> layers;

  Puzzle() {
    layers = new List<MeshGrid>();
  }

  List<String> parseInputByLine() {
    return input = inputFile.readAsStringSync().trim().split("\n");
  }

  List<String> parseInputBySeparator({String separator = ","}) {
    return input = inputFile.readAsStringSync().trim().split(separator);
  }

  void solvePart1() {
    parseInputBySeparator();
    var layers = new List<List<int>>();
    var layerCount = 0;
    for (int i = 0; i < input[0].length; i++) {
      layerCount = i ~/ (6 * 25);
      if (layers.length < layerCount + 1) {
        layers.add(new List<int>());
      }
      layers[layerCount].add(int.parse(input[0][i]));
    }
    var layer_count = new List<List<int>>();
    for (var l in layers) {
      layer_count.add([
        l.where((n) => n == 0).length,
        l.where((n) => n == 1).length,
        l.where((n) => n == 2).length
      ]);
    }
    layer_count.sort((a, b) => a[0].compareTo(b[0]));
    solution1 = layer_count[0][1] * layer_count[0][2];
  }

  void solvePart2() {
    var layerCount = 0, position = 0;
    for (int i = 0; i < input[0].length; i++) {
      layerCount = i ~/ (6 * 25);
      if (layers.length < layerCount + 1) {
        layers.add(new MeshGrid(25, 6, 0));
      }
      position = i - (6 * 25 * layerCount);
      layers[layerCount][position % 25][position ~/ 25] =
          num.parse(input[0][i]);
    }
    GifEncoder encoder = new GifEncoder(repeat: 1, delay: 10);
    Image image = Image(251, 61);
    fill(image, getColor(128, 128, 128)); // gray is transparent
    encoder.addFrame(image, duration: 3);
    for (var l in layers.reversed) {
      for (var x = 0; x < 25; x++) {
        for (var y = 0; y < 6; y++) {
          if (l[x][y] == 2) continue;
          if (l[x][y] == 0) {
            fillRect(image, x * 10, y * 10, (x + 1) * 10, (y + 1) * 10,
                getColor(0, 0, 0));
          } else {
            fillRect(image, x * 10, y * 10, (x + 1) * 10, (y + 1) * 10,
                getColor(255, 255, 255));
          }
        }
      }
      encoder.addFrame(image, duration: 3);
    }
    File('output08.gif').writeAsBytesSync(encoder.finish());
  }
}

void main() {
  Puzzle puzzle = new Puzzle();

  Stopwatch stopwatch = new Stopwatch();
  stopwatch.start();
  puzzle.solvePart1();
  puzzle.solvePart2();
  stopwatch.stop();

  print("Solution to part1: ${puzzle.solution1}");
  print("Solution to part2: ${puzzle.solution2}");
  print("Execution took ${stopwatch.elapsed}");
}
