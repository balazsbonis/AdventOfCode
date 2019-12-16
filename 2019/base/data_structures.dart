library data_structures;

import 'dart:mirrors';

class MeshGrid implements List<List<num>> {
  final List<List<num>> _grid;
  int get width => _grid.length;
  int get height => _grid[0].length;

  MeshGrid(int width, int height, [num filler = 0])
      : _grid =
            new List.generate(width, (_) => new List.filled(height, filler));

  noSuchMethod(Invocation invocation) => //super.noSuchMethod(invocation);
      reflect(_grid).delegate(invocation);

  @override
  String toString() {
    String result = "";
    for (int i = 0; i < width; i++) {
      result += "[";
      for (int j = 0; j < height; j++) {
        result += this[i][j].toString().padLeft(4);
      }
      result += "]\n";
    }
    return result;
  }

  List<num> flatten(){
    return _grid.reduce((value, element) => value.followedBy(element).toList());
  }
}

class Node {
  final String name;
  final depth;

  List<Node> nodes;
  Node parent;

  Set<List<String>> _inputs;
  List<Node> _visitedNodes = new List<Node>();

  Node(this.name, this.depth, [this.parent]) {
    nodes = new List<Node>();
  }

  @override
  bool operator ==(Object other) => other is Node && other.name == name;

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() {
    return "${name} -> (${nodes.join("\n\t")})";
  }

  int depthFirstCrawl() {
    return _depthFirstCrawl(this);
  }

  Node findNode(String name) {
    return _findNode(this, name);
  }

  void buildTree(Set<List<String>> inputs) {
    _inputs = inputs;
    this.nodes = _buildTree(this, 1);
  }

  int getDistance(String source, String target){
    var sourceNode = findNode(source);
    return _getDistance(sourceNode, target, -1); // initial node doesn't count
  }

  int _getDistance(Node source, String target, int distance) {
    if (source.name == target) {
      return distance -
          1; // we already reached the destination, don't need to add 1 more
    }

    _visitedNodes.add(source);
    // first check all the children
    for (var n in source.nodes.where((f) => !_visitedNodes.contains(f))) {
      //print("v ${source.name} -> ${n.name}; $distance");
      return _getDistance(n, target, distance + 1);
    }

    if (!_visitedNodes.contains(source.parent)) {
      // check the parent
      //print("^ ${source.name} -> ${source.parent.name}; $distance");
      return _getDistance(source.parent, target, distance + 1);
    }
    // dead-end, go back all the way
    return _getDistance(source.parent, target, distance - 1);
  }

  static int _depthFirstCrawl(Node root) {
    if (root.nodes.length == 0) return root.depth;
    var result = root.depth;
    root.nodes.forEach((f) => result += _depthFirstCrawl(f));
    return result;
  }

  static Node _findNode(Node root, String name) {
    if (root.name == name) return root;
    for (var n in root.nodes) {
      var found = _findNode(n, name);
      if (found != null) {
        return found;
      }
    }
  }

  List<Node> _buildTree(Node root, int depth) {
    var inputsToAdd = _inputs.where((f) => f[0] == root.name);
    inputsToAdd.forEach((f) => root.nodes.add(new Node(f[1], depth, root)));
    for (var n in root.nodes) {
      n.nodes = _buildTree(n, depth + 1);
    }
    return root.nodes;
  }
}
