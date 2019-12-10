library intcode_compiler;

class Tape {
  List<int> memory;
  int pointer = 0;

  Tape(this.memory, this.pointer);

  int getNext(int offset) {
    return memory[pointer + offset];
  }

  int getValue(int from) {
    if (memory.length < from) {
      memory = memory
          .followedBy(new List<int>.filled(from - memory.length + 2, 0))
          .toList();
    }
    return memory[from];
  }

  void setValue(int position, int value) {
    if (memory.length < position) {
      memory = memory
          .followedBy(new List<int>.filled(position - memory.length + 2, 0))
          .toList();
    }
    memory[position] = value;
  }

  @override
  String toString() {
    return "$memory \n @${pointer} [${memory[pointer]}]";
  }
}

class Runner {
  Tape tape;
  List<int> params;
  static int paramPointer = 0;
  static int relativeBase = 0;
  static bool printToConsole = false;
  int lastOutput = -1;

  Runner(List<int> memory, [this.params]) {
    tape = new Tape(memory, 0);
  }

  void reset() {
    paramPointer = 0;
    relativeBase = 0;
    printToConsole = false;
  }

  void run() {
    tape.pointer = 0;
    while (tape.pointer != -1) {
      if (printToConsole) {
        //print(tape.toString()); // uncomment for tape snapshot
      }
      var instruction = new Instruction(tape, params);
      var result = instruction.work();
      if (result != null) {
        lastOutput = result;
      }
      tape.pointer += instruction.skip;
    }
  }

  void enablePrint() {
    printToConsole = true;
  }
}

class Instruction {
  int skip = 0;
  Function work;

  int parseInputParam(Tape tape, String mode, int position) {
    return tape.getValue(mode == "0"
        ? tape.getValue(position)
        : mode == "1"
            ? position
            : Runner.relativeBase + tape.getValue(position));
  }

  int parseOutputParam(Tape tape, String mode, int position) {
    return mode == "0"
        ? tape.getValue(position)
        : Runner.relativeBase + tape.getValue(position);
  }

  Instruction(Tape tape, List<int> params) {
    var raw = tape.getValue(tape.pointer).toString().padLeft(5, '0');
    var opcode = raw[3] + raw[4];

    if (opcode != "99") {
      var p1Mode = raw[2],
          p2Mode = raw[1],
          p3Mode = raw[0]; // 0 = position, 1 = absolute, 2 = relative
      int p1, p2, p3;

      switch (opcode) {
        case ("01"):
          // addition
          p1 = parseInputParam(tape, p1Mode, tape.pointer + 1);
          p2 = parseInputParam(tape, p2Mode, tape.pointer + 2);
          p3 = parseOutputParam(tape, p3Mode, tape.pointer + 3);
          work = () {
            if (Runner.printToConsole) print(" ADD> ${p1} + ${p2}");
            tape.setValue(p3, p1 + p2);
          };
          skip = 4;
          break;
        case ("02"):
          // multiplication
          p1 = parseInputParam(tape, p1Mode, tape.pointer + 1);
          p2 = parseInputParam(tape, p2Mode, tape.pointer + 2);
          p3 = parseOutputParam(tape, p3Mode, tape.pointer + 3);
          work = () {
            if (Runner.printToConsole) print(" MUL> ${p1} * ${p2}");
            tape.setValue(p3, p1 * p2);
          };
          skip = 4;
          break;
        case ("03"):
          // input
          var inputParam = params[Runner.paramPointer];
          print("READ> ${inputParam}");
          work = () {
            tape.setValue(
                p1Mode == "0"
                    ? tape.getValue(tape.pointer + 1)
                    : (tape.getValue(tape.pointer + 1) + Runner.relativeBase),
                inputParam);
            Runner.paramPointer++;
          };
          skip = 2;
          break;
        case ("04"):
          // output
          p1 = parseInputParam(tape, p1Mode, tape.pointer + 1);
          work = () {
            print("PRNT> ${p1}");
            return p1;
          };
          skip = 2;
          break;
        case ("05"):
          // jump-if-non-zero
          p1 = parseInputParam(tape, p1Mode, tape.pointer + 1);
          p2 = parseInputParam(tape, p2Mode, tape.pointer + 2);
          work = () {
            if (Runner.printToConsole) print(" J!0> ${p1} != 0?");
            skip = p1 != 0 ? p2 - tape.pointer : 3;
          };
          break;
        case ("06"):
          // jump-if-zero
          p1 = parseInputParam(tape, p1Mode, tape.pointer + 1);
          p2 = parseInputParam(tape, p2Mode, tape.pointer + 2);
          work = () {
            if (Runner.printToConsole) print(" J=0> ${p1} != 0?");
            skip = p1 == 0 ? p2 - tape.pointer : 3;
          };
          break;
        case ("07"):
          // less than
          p1 = parseInputParam(tape, p1Mode, tape.pointer + 1);
          p2 = parseInputParam(tape, p2Mode, tape.pointer + 2);
          p3 = parseOutputParam(tape, p3Mode, tape.pointer + 3);
          work = () {
            if (Runner.printToConsole) print(" LES> ${p1} < ${p2}?");
            tape.setValue(p3, p1 < p2 ? 1 : 0);
          };
          skip = 4;
          break;
        case ("08"):
          // equals
          p1 = parseInputParam(tape, p1Mode, tape.pointer + 1);
          p2 = parseInputParam(tape, p2Mode, tape.pointer + 2);
          p3 = parseOutputParam(tape, p3Mode, tape.pointer + 3);
          work = () {
            if (Runner.printToConsole) print(" EQU> ${p1} == ${p2}?");
            tape.setValue(p3, p1 == p2 ? 1 : 0);
          };
          skip = 4;
          break;
        case ("09"):
          p1 = parseInputParam(tape, p1Mode, tape.pointer + 1);
          work = () {
            if (Runner.printToConsole) print(" SHR> +(${p1})");
            Runner.relativeBase += p1;
          };
          skip = 2;
          break;
      }
    } else {
      work = () {
        print(" END> ---");
      };
      skip = -(tape.pointer + 1);
    }
  }
}
