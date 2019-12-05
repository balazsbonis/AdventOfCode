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
    //var memory = [3,3,1105,-1,9,1101,0,0,12,4,12,99,1];
    var pointer = 0;
    while (pointer != -1) {
      //print(memory);
      //print("Pointer: ${pointer} [${memory[pointer]}]");
      var instruction = new Instruction(memory, pointer);
      instruction.work();
      pointer += instruction.skip;
    }
    // 11981754
  }
}

class Instruction {
  List<int> operands;
  int skip = 0;
  Function work;

  Instruction(List<int> memory, int pointer) {
    operands = new List<int>();
    var raw = memory[pointer].toString().padLeft(5, '0');
    var opcode = raw[3] + raw[4];

    if (opcode != "99") {
      var p1 =
          raw[2] == "0" ? memory[memory[pointer + 1]] : memory[pointer + 1];
      var p2 =
          raw[1] == "0" ? memory[memory[pointer + 2]] : memory[pointer + 2];

      switch (opcode) {
        case ("01"):
          // addition
          work = () {
            print("! ${p1} + ${p2}");
            memory[memory[pointer + 3]] = p1 + p2;
          };
          skip = 4;
          break;
        case ("02"):
          // multiplication
          work = () {
            print("! ${p1} * ${p2}");
            memory[memory[pointer + 3]] = p1 * p2;
          };
          skip = 4;
          break;
        case ("03"):
          // input
          work = () {
            var inputParam = 5;
            memory[memory[pointer + 1]] = inputParam; // 1 = input AC
            print("READ> ${inputParam}");
          };
          skip = 2;
          break;
        case ("04"):
          // output
          work = () {
            print(
                "--- --- --- === CONSOLE OUTPUT: ${memory[memory[pointer + 1]]} === --- --- ---");
          };
          skip = 2;
          break;
        case ("05"):
          // jump-if-true
          work = () {
            print("  ${p1} != 0?");
            skip = p1 != 0 ? p2 - pointer : 3;
          };
          break;
        case ("06"):
          // jump-if-false
          work = () {
            print("  ${p1} == 0?");
            skip = p1 == 0 ? p2 - pointer : 3;
          };
          break;
        case ("07"):
          // less than
          work = () {
            print("  ${p1} < ${p2}?");
            memory[memory[pointer + 3]] = p1 < p2 ? 1 : 0;
          };
          skip = 4;
          break;
        case ("08"):
          // equals
          work = () {
            print("  ${p1} == ${p2}?");
            memory[memory[pointer + 3]] = p1 == p2 ? 1 : 0;
          };
          skip = 4;
          break;
      }
    } else {
      work = () {
        print("Ended.");
      };
      skip = -(pointer + 1);
    }
  }
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
