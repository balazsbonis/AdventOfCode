library graph;

class Node {
  final String name;
  final depth;
  List<Node> nodes;
  Node parent;

  Node(this.name, this.depth, [this.parent]) {
    nodes = new List<Node>();
  }

  @override
  bool operator ==(Object other) => other is Node && other.name == name;

  @override
  int get hashCode => name.hashCode;

  Node findDepthFirst(Node node) {
    if (this == node) return this;
    for (var n in nodes) {
      return findDepthFirst(n);
    }
    return null;
  }

  @override
  String toString() {
    return "${name} -> (${nodes.join("\n\t")})";
  }
}
