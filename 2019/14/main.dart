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
  List<Reaction> children;

  Reaction(this.result, this.reagents);

  Reaction.fromString(String input) {
    children = new List<Reaction>();
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
  Map inventory;
  Map neededMaterials;

  Puzzle() {
    reactions = new List<Reaction>();
    inventory = new Map();
    neededMaterials = new Map();
  }

  List<String> parseInputByLine() {
    return input = inputFile.readAsStringSync().trim().split("\n");
  }

  List<String> parseInputBySeparator({String separator = ","}) {
    return input = inputFile.readAsStringSync().trim().split(separator);
  }

  void solve() {
    input = parseInputByLine();
    for (var i in input) {
      reactions.add(new Reaction.fromString(i));
    }
    solution1 = getQuantity("FUEL", 1);
    for (var i = 3412000; i < 3483972; i++) {
      var result = getQuantity("FUEL", i);
      if (result <= 1000000000000) {
        // 3412430 - x - too high
        // 3412429 - WHY.
        print("$i - $result");
        solution2 = i;
      } else {
        break;
      }
    }
  }

  void solveTestSimple() {
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
    solution1 = getQuantity("FUEL", 1);
  }

  void solveTestComplex() {
    input = [
      "171 ORE => 8 CNZTR",
      "7 ZLQW, 3 BMBT, 9 XCVML, 26 XMNCP, 1 WPTQ, 2 MZWV, 1 RJRHP => 4 PLWSL",
      "114 ORE => 4 BHXH",
      "14 VRPVC => 6 BMBT",
      "6 BHXH, 18 KTJDG, 12 WPTQ, 7 PLWSL, 31 FHTLT, 37 ZDVW => 1 FUEL",
      "6 WPTQ, 2 BMBT, 8 ZLQW, 18 KTJDG, 1 XMNCP, 6 MZWV, 1 RJRHP => 6 FHTLT",
      "15 XDBXC, 2 LTCX, 1 VRPVC => 6 ZLQW",
      "13 WPTQ, 10 LTCX, 3 RJRHP, 14 XMNCP, 2 MZWV, 1 ZLQW => 1 ZDVW",
      "5 BMBT => 4 WPTQ",
      "189 ORE => 9 KTJDG",
      "1 MZWV, 17 XDBXC, 3 XCVML => 2 XMNCP",
      "12 VRPVC, 27 CNZTR => 2 XDBXC",
      "15 KTJDG, 12 BHXH => 5 XCVML",
      "3 BHXH, 2 VRPVC => 7 MZWV",
      "121 ORE => 7 VRPVC",
      "7 XCVML => 6 RJRHP",
      "5 BHXH, 4 VRPVC => 5 LTCX"
    ];
    for (var i in input) {
      reactions.add(new Reaction.fromString(i));
    }
    solution1 = getQuantity("FUEL", 1);
  }

  int getQuantity(String product, int quantity) {
    var reaction = reactions.where((x) => x.result.name == product).first;
    var surplus =
        quantity - (inventory.containsKey(product) ? inventory[product] : 0);
    var multiple =
        ((surplus > 0 ? surplus : 0) / reaction.result.quantity).ceil();
    inventory[product] = (reaction.result.quantity) * multiple - surplus;
    //print(inventory);
    var ore = 0;
    for (var reagent in reaction.reagents) {
      if (reagent.name == "ORE") {
        ore += multiple * reagent.quantity;
      } else {
        ore += getQuantity(reagent.name, multiple * reagent.quantity);
      }
    }
    return ore;
  }

  List<Reaction> buildTree(Reaction ending) {
    // build graph
    for (var reagent in ending.reagents) {
      ending.children
          .addAll(reactions.where((f) => reagent.name == f.result.name));
    }
    for (var n in ending.children) {
      n.children = buildTree(n);
    }
    print(inventory);
    return ending.children;
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
