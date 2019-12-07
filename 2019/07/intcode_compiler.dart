library intcode_compiler;

class Runner {
  List<int> memory;
  List<int> params;
  int pointer = 0;
  static int paramPointer = 0;
  static bool printToConsole = false;
  int lastOutput = -1;

  Runner(this.memory, [this.params]);

  void run() {
    pointer = 0;
    paramPointer = 0;
    while (pointer != -1) {
      if (printToConsole) {
        print(memory);
        print("Pointer: ${pointer} [${memory[pointer]}]");
      }
      var instruction = new Instruction(memory, params, pointer);
      var result = instruction.work();
      if (result != null){
        lastOutput = result;
      }
      pointer += instruction.skip;
    }
  }
}

class Instruction {
  int skip = 0;
  Function work;

  Instruction(
      List<int> memory, List<int> params, int pointer) {
    var raw = memory[pointer].toString().padLeft(5, '0');
    var opcode = raw[3] + raw[4];

    if (opcode != "99") {
      var p1 =
          raw[2] == "0" ? memory[memory[pointer + 1]] : memory[pointer + 1];
      var p2 = raw[1] == "0" && memory[pointer + 2] <= memory.length
          ? memory[memory[pointer + 2]]
          : memory[pointer + 2];

      switch (opcode) {
        case ("01"):
          // addition
          work = () {
            if (Runner.printToConsole) print("! ${p1} + ${p2}");
            memory[memory[pointer + 3]] = p1 + p2;
          };
          skip = 4;
          break;
        case ("02"):
          // multiplication
          work = () {
            if (Runner.printToConsole) print("! ${p1} * ${p2}");
            memory[memory[pointer + 3]] = p1 * p2;
          };
          skip = 4;
          break;
        case ("03"):
          // input
          work = () {
            var inputParam = params[Runner.paramPointer];
            memory[memory[pointer + 1]] = inputParam;
            Runner.paramPointer++;
            print("READ> ${inputParam}");
          };
          skip = 2;
          break;
        case ("04"):
          // output
          work = () {
            print(
                "--- --- --- === CONSOLE OUTPUT: ${memory[memory[pointer + 1]]} === --- --- ---");
                return memory[memory[pointer+1]];
          };
          skip = 2;
          break;
        case ("05"):
          // jump-if-true
          work = () {
            if (Runner.printToConsole) print("  ${p1} != 0?");
            skip = p1 != 0 ? p2 - pointer : 3;
          };
          break;
        case ("06"):
          // jump-if-false
          work = () {
            if (Runner.printToConsole) print("  ${p1} == 0?");
            skip = p1 == 0 ? p2 - pointer : 3;
          };
          break;
        case ("07"):
          // less than
          work = () {
            if (Runner.printToConsole) print("  ${p1} < ${p2}?");
            memory[memory[pointer + 3]] = p1 < p2 ? 1 : 0;
          };
          skip = 4;
          break;
        case ("08"):
          // equals
          work = () {
            if (Runner.printToConsole) print("  ${p1} == ${p2}?");
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
