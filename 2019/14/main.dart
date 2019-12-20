import 'dart:io';

class Element {
  String name;
  int quantity;

  Element(this.name, this.quantity);

  Element.fromString(String input) {
    var parts = input.split(" ");
    quantity = int.parse(parts[0]);
    name = parts[1];
  }
}

class Reaction {
  Element result;
  List<Element> reagents;

  Reaction(this.result, this.reagents);

  Reaction.fromString(String input) {
    reagents = new List<Element>();
    var parts = input.split("=>");
    var elementParts = parts[0].trim();
    var resultPart = parts[1].trim();
    result = new Element.fromString(resultPart);
    for (var p in elementParts.split(",")) {
      reagents.add(new Element.fromString(p.trim()));
    }
  }
}

class Puzzle {
  final inputFile = new File(".\\14\\input.txt");
  List<String> input = new List<String>();
  dynamic solution1;
  dynamic solution2;
  List<Reaction> reactions;

  Puzzle() {
    reactions = new List<Reaction>();
  }

  List<String> parseInputByLine() {
    return input = inputFile.readAsStringSync().trim().split("\n");
  }

  List<String> parseInputBySeparator({String separator = ","}) {
    return input = inputFile.readAsStringSync().trim().split(separator);
  }

  void solve() {}

  void solveTest() {
    input = [
      "9 ORE => 2 A",
      "8 ORE => 3 B",
      "7 ORE => 5 C",
      "3 A, 4 B => 1 AB",
      "5 B, 7 C => 1 BC",
      "4 C, 1 A => 1 CA",
      "2 AB, 3 BC, 4 CA => 1 FUEL"
    ];
    for (var i in input) {
      reactions.add(new Reaction.fromString(i));
    }
    // find the one reaction with fuel
    var ending = reactions.where((x) => x.result.name == "FUEL").first;
    print("M");
  }

  
}

void main() {
  Puzzle puzzle = new Puzzle();

  Stopwatch stopwatch = new Stopwatch();
  stopwatch.start();
  puzzle.solveTest();
  stopwatch.stop();

  print("Solution to part1: ${puzzle.solution1}");
  print("Solution to part2: ${puzzle.solution2}");
  print("Execution took ${stopwatch.elapsed}");
}
