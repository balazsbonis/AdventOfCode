import 'dart:collection';
import 'dart:io';
import 'graph.dart';

class Puzzle {
  final inputFile = new File(".\\06\\input.txt");
  List<String> input = new List<String>();
  dynamic solution1;
  dynamic solution2;
  Set<List<String>> inputToProcess;

  Puzzle() {}

  List<String> parseInputByLine() {
    return input = inputFile.readAsStringSync().trim().split("\n");
  }

  List<String> parseInputBySeparator({String separator = ","}) {
    return input = inputFile.readAsStringSync().trim().split(separator);
  }

  void solve() {
    inputToProcess = parseInputByLine().map((f) => f.split(")")).toSet();

    // find root node and build tree
    var rootNames = inputToProcess.map((p) => p[0]);
    var nodeNames = inputToProcess.map((p) => p[1]);
    var rootNode =
        new Node(rootNames.firstWhere((f) => !nodeNames.contains(f)), 0);

    rootNode.buildTree(inputToProcess);
    solution1 = rootNode.depthFirstCrawl();
    solution2 = rootNode.getDistance("YOU", "SAN"); 
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
