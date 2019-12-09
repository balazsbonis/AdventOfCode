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

  void run() {
    tape.pointer = 0;
    paramPointer = 0;
    while (tape.pointer != -1) {
      if (printToConsole) {
        print(tape.toString());
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
          if (p1Mode == "0") {
            p1 = tape.getValue(tape.getValue(tape.pointer + 1));
          } else if (p1Mode == "1") {
            p1 = tape.getValue(tape.pointer + 1);
          } else if (p1Mode == "2") {
            p1 = tape.getValue(
                tape.getValue(tape.pointer + 1) + Runner.relativeBase);
          }

          if (p2Mode == "0") {
            p2 = tape.getValue(tape.getValue(tape.pointer + 2));
          } else if (p2Mode == "1") {
            p2 = tape.getValue(tape.pointer + 2);
          } else if (p2Mode == "2") {
            p2 = tape.getValue(
                tape.getValue(tape.pointer + 2) + Runner.relativeBase);
          }

          if (p3Mode == "0") {
            p3 = tape
                .getValue(tape.pointer + 3); // p1 + p2 written directly to p3
          } else if (p3Mode == "2") {
            p3 = tape.getValue(
                Runner.relativeBase + tape.getValue(tape.pointer + 3));
          }

          work = () {
            if (Runner.printToConsole) print("! ${p1} + ${p2}");
            tape.setValue(p3, p1 + p2);
          };
          skip = 4;
          break;
        case ("02"):
          // multiplication
          if (p1Mode == "0") {
            p1 = tape.getValue(tape.getValue(tape.pointer + 1));
          } else if (p1Mode == "1") {
            p1 = tape.getValue(tape.pointer + 1);
          } else if (p1Mode == "2") {
            p1 = tape.getValue(
                tape.getValue(tape.pointer + 1) + Runner.relativeBase);
          }

          if (p2Mode == "0") {
            p2 = tape.getValue(tape.getValue(tape.pointer + 2));
          } else if (p2Mode == "1") {
            p2 = tape.getValue(tape.pointer + 2);
          } else if (p2Mode == "2") {
            p2 = tape.getValue(
                Runner.relativeBase + tape.getValue(tape.pointer + 2));
          }

          if (p3Mode == "0") {
            p3 = tape
                .getValue(tape.pointer + 3); // p1 * p2 written directly to p3
          } else if (p3Mode == "2") {
            p3 = tape.getValue(
                Runner.relativeBase + tape.getValue(tape.pointer + 3));
          }

          work = () {
            if (Runner.printToConsole) print("! ${p1} * ${p2}");
            tape.setValue(p3, p1 * p2);
          };
          skip = 4;
          break;
        case ("03"):
          // input
          work = () {
            var inputParam = params[Runner.paramPointer];
            switch (p1Mode) {
              case "0":
                tape.setValue(tape.getValue(tape.pointer + 1), inputParam);
                break;
              case "1":
                break;
              case "2":
                tape.setValue(
                    tape.getValue(tape.pointer + 1) + Runner.relativeBase,
                    inputParam);
                break;
            }
            Runner.paramPointer++;
            print("READ> ${inputParam}");
          };
          skip = 2;
          break;
        case ("04"):
          // output
          work = () {
            if (p1Mode == "0") {
              p1 = tape.getValue(tape.getValue(tape.pointer + 1));
            } else if (p1Mode == "1") {
              p1 = tape.getValue(tape.pointer + 1);
            } else if (p1Mode == "2") {
              p1 = tape.getValue(
                  tape.getValue(tape.pointer + 1) + Runner.relativeBase);
            }

            print("--- --- --- === CONSOLE OUTPUT: ${p1} === --- --- ---");
            return p1;
          };
          skip = 2;
          break;
        case ("05"):
          // jump-if-non-zero
          work = () {
            if (p1Mode == "0") {
              p1 = tape.getValue(tape.getValue(tape.pointer + 1));
            } else if (p1Mode == "1") {
              p1 = tape.getValue(tape.pointer + 1);
            } else if (p1Mode == "2") {
              p1 = tape.getValue(
                  tape.getValue(tape.pointer + 1) + Runner.relativeBase);
            }

            if (p2Mode == "0") {
              p2 = tape.getValue(tape.getValue(tape.pointer + 2));
            } else if (p2Mode == "1") {
              p2 = tape.getValue(tape.pointer + 2);
            } else if (p2Mode == "2") {
              p2 = tape.getValue(
                  tape.getValue(tape.pointer + 2) + Runner.relativeBase);
            }

            if (Runner.printToConsole) print("  ${p1} == 0?");
            skip = p1 != 0 ? p2 - tape.pointer : 3;
          };
          break;
        case ("06"):
          // jump-if-zero
          work = () {
            if (p1Mode == "0") {
              p1 = tape.getValue(tape.getValue(tape.pointer + 1));
            } else if (p1Mode == "1") {
              p1 = tape.getValue(tape.pointer + 1);
            } else if (p1Mode == "2") {
              p1 = tape.getValue(
                  tape.getValue(tape.pointer + 1) + Runner.relativeBase);
            }

            if (p2Mode == "0") {
              p2 = tape.getValue(tape.getValue(tape.pointer + 2));
            } else if (p2Mode == "1") {
              p2 = tape.getValue(tape.pointer + 2);
            } else if (p2Mode == "2") {
              p2 = tape.getValue(
                  tape.getValue(tape.pointer + 2) + Runner.relativeBase);
            }

            if (Runner.printToConsole) print("  ${p1} != 0?");
            skip = p1 == 0 ? p2 - tape.pointer : 3;
          };
          break;
        case ("07"):
          // less than
          work = () {
            if (p1Mode == "0") {
              p1 = tape.getValue(tape.getValue(tape.pointer + 1));
            } else if (p1Mode == "1") {
              p1 = tape.getValue(tape.pointer + 1);
            } else if (p1Mode == "2") {
              p1 = tape.getValue(
                  Runner.relativeBase + tape.getValue(tape.pointer + 1));
            }
            if (p2Mode == "0") {
              p2 = tape.getValue(tape.getValue(tape.pointer + 2));
            } else if (p2Mode == "1") {
              p2 = tape.getValue(tape.pointer + 2);
            } else if (p2Mode == "2") {
              p2 = tape.getValue(
                  Runner.relativeBase + tape.getValue(tape.pointer + 2));
            }
            if (p3Mode == "0") {
              p3 = tape.getValue(
                  tape.pointer + 3); // p1 == p2 written directly to p3
            } else if (p3Mode == "2") {
              p3 = tape.getValue(
                  Runner.relativeBase + tape.getValue(tape.pointer + 3));
            }

            if (Runner.printToConsole) print("  ${p1} < ${p2}?");
            tape.setValue(p3, p1 < p2 ? 1 : 0);
          };
          skip = 4;
          break;
        case ("08"):
          // equals
          work = () {
            if (p1Mode == "0") {
              p1 = tape.getValue(tape.getValue(tape.pointer + 1));
            } else if (p1Mode == "1") {
              p1 = tape.getValue(tape.pointer + 1);
            } else if (p1Mode == "2") {
              p1 = tape.getValue(
                  Runner.relativeBase + tape.getValue(tape.pointer + 1));
            }
            if (p2Mode == "0") {
              p2 = tape.getValue(tape.getValue(tape.pointer + 2));
            } else if (p2Mode == "1") {
              p2 = tape.getValue(tape.pointer + 2);
            } else if (p2Mode == "2") {
              p2 = tape.getValue(
                  Runner.relativeBase + tape.getValue(tape.pointer + 2));
            }

            if (p3Mode == "0") {
              p3 = tape.getValue(
                  tape.pointer + 3); // p1 == p2 written directly to p3
            } else if (p3Mode == "2") {
              p3 = tape.getValue(
                  Runner.relativeBase + tape.getValue(tape.pointer + 3));
            }
            if (Runner.printToConsole) print("  ${p1} == ${p2}?");
            tape.setValue(p3, p1 == p2 ? 1 : 0);
          };
          skip = 4;
          break;
        case ("09"):
          work = () {
            if (p1Mode == "0") {
              p1 = tape.getValue(tape.getValue(tape.pointer + 1));
            } else if (p1Mode == "1") {
              p1 = tape.getValue(tape.pointer + 1);
            } else if (p1Mode == "2") {
              p1 = tape.getValue(
                  tape.getValue(tape.pointer + 1) + Runner.relativeBase);
            }
            if (Runner.printToConsole) print("R +(${p1})");
            Runner.relativeBase += p1;
          };
          skip = 2;
          break;
      }
    } else {
      work = () {
        print("Ended.");
      };
      skip = -(tape.pointer + 1);
    }
  }
}
