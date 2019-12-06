import 'dart:collection';
import 'dart:io';
import 'graph.dart';

class Puzzle {
  final inputFile = new File(".\\06\\input.txt");
  List<String> input = new List<String>();
  dynamic solution1;
  dynamic solution2;

  Set<List<String>> inputToProcess;
  List<Node> visitedNodes = new List<Node>();

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

    rootNode.nodes = buildTree(rootNode, 1);
    solution1 = depthFirstCrawl(rootNode);
    solution2 = getDistance(findNode(rootNode, "YOU"), "SAN", -1); // initial node doesn't count

    print(rootNode);
  }

  List<Node> buildTree(Node root, int depth) {
    var inputsToAdd = inputToProcess.where((f) => f[0] == root.name);
    inputsToAdd.forEach((f) => root.nodes.add(new Node(f[1], depth, root)));
    for (var n in root.nodes) {
      n.nodes = buildTree(n, depth + 1);
    }
    return root.nodes;
  }

  int depthFirstCrawl(Node root) {
    if (root.nodes.length == 0) return root.depth;
    var result = root.depth;
    root.nodes.forEach((f) => result += depthFirstCrawl(f));
    return result;
  }

  Node findNode(Node root, String name) {
    if (root.name == name) return root;
    for (var n in root.nodes) {
      var found = findNode(n, name);
      if (found != null) {
        return found;
      }
    }
  }

  int getDistance(Node source, String target, int distance) {
    if (source.name == target) {
      return distance - 1; // we already reached the destination, don't need to add 1 more
    }

    visitedNodes.add(source);
    // first check all the children
    for (var n in source.nodes.where((f) => !visitedNodes.contains(f))) {
      print("v ${source.name} -> ${n.name}; $distance");
      return getDistance(n, target, distance + 1);
    }

    if (!visitedNodes.contains(source.parent)) {
      print("^ ${source.name} -> ${source.parent.name}; $distance");
      return getDistance(source.parent, target, distance + 1);
    }
    return getDistance(source.parent, target, distance - 1);
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
