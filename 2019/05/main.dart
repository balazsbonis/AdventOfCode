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

    switch (opcode) {
      case ("01"):
        // addition
        work = () {
          var a =
              raw[2] == "0" ? memory[memory[pointer + 1]] : memory[pointer + 1];
          var b =
              raw[1] == "0" ? memory[memory[pointer + 2]] : memory[pointer + 2];
          print("${a} + ${b}");
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
          print("${a} * ${b}");
          memory[memory[pointer + 3]] = a * b;
        };
        skip = 4;
        break;
      case ("03"):
        // input
        work = () {
          var inputParam = 5;
          memory[memory[pointer + 1]] = inputParam; // 1 = input AC
          print("Read ${inputParam}");
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
          var check =
              raw[2] == "0" ? memory[memory[pointer + 1]] : memory[pointer + 1];
          print("${check} != 0?");
          if (check != 0) {
            var jump = raw[1] == "0"
                ? memory[memory[pointer + 2]]
                : memory[pointer + 2];
            skip = jump - pointer;
          } else {
            skip = 3;
          }
        };
        break;
      case ("06"):
        // jump-if-false
        work = () {
          var check =
              raw[2] == "0" ? memory[memory[pointer + 1]] : memory[pointer + 1];
          print("${check} == 0?");
          if (check == 0) {
            var jump = raw[1] == "0"
                ? memory[memory[pointer + 2]]
                : memory[pointer + 2];
            skip = jump - pointer;
          } else {
            skip = 3;
          }
        };
        break;
      case ("07"):
        // less than
        work = () {
          var checkSmall =
              raw[2] == "0" ? memory[memory[pointer + 1]] : memory[pointer + 1];
          var checkLarge =
              raw[1] == "0" ? memory[memory[pointer + 2]] : memory[pointer + 2];
          var result = memory[pointer + 3];
          print("${checkSmall} < ${checkLarge}?");
          memory[result] = checkSmall < checkLarge ? 1 : 0;
        };
        skip = 4;
        break;
      case ("08"):
        // equals
        work = () {
          var checkSmall =
              raw[2] == "0" ? memory[memory[pointer + 1]] : memory[pointer + 1];
          var checkLarge =
              raw[1] == "0" ? memory[memory[pointer + 2]] : memory[pointer + 2];
          var result = memory[pointer + 3];
          print("${checkSmall} == ${checkLarge}?");
          memory[result] = checkSmall == checkLarge ? 1 : 0;
        };
        skip = 4;
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
