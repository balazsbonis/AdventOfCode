import 'dart:convert';
import 'dart:io';

class Puzzle {
  final inputFile = new File(".\\05\\input.txt");
  List<String> input = new List<String>();

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
    var pointer = 0;
    while (pointer != -1) {
      var instruction = new Instruction(memory, pointer);
      instruction.work();
      pointer += instruction.skip;
    }
  }
}

class Instruction {
  List<int> operands;
  int skip = 0;

  Instruction(List<int> memory, int pointer) {
    operands = new List<int>();
    var raw = memory[pointer].toString().padLeft(5, '0');
    var opcode = raw[3] + raw[4];

    switch (opcode) {
      case ("01"):
        // addition
        work = () {
          var a =
              raw[2] == "0" ? memory[memory[pointer + 1]] : memory[pointer + 1];
          var b =
              raw[1] == "0" ? memory[memory[pointer + 2]] : memory[pointer + 2];
          memory[memory[pointer + 3]] = a + b;
        };
        skip = 4;
        break;
      case ("02"):
        // multiplication
        work = () {
          var a =
              raw[2] == "0" ? memory[memory[pointer + 1]] : memory[pointer + 1];
          var b =
              raw[1] == "0" ? memory[memory[pointer + 2]] : memory[pointer + 2];
          memory[memory[pointer + 3]] = a * b;
        };
        skip = 4;
        break;
      case ("03"):
        // input
        work = () {
          //var line = stdin.readLineSync(encoding: Encoding.getByName("utf-8"));
          memory[memory[pointer + 1]] = 1;
        };
        skip = 2;
        break;
      case ("04"):
        // output
        work = () {
          print(memory[memory[pointer + 1]]);
        };
        skip = 2;
        break;
      case ("99"):
        // end
        work = () {
          print("Ended.");
        };
        skip = -(pointer + 1);
        break;
    }
  }

  Function work;
}

void main() {
  Puzzle puzzle = new Puzzle();
  print("Start");

  Stopwatch stopwatch = new Stopwatch();
  stopwatch.start();
  puzzle.solve();
  stopwatch.stop();

  print("Execution took ${stopwatch.elapsed}");
}
