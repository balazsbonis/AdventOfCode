import 'dart:io';

class Puzzle {
  final inputFile = new File(".\\16\\input.txt");
  List<String> input = new List<String>();
  dynamic solution1;
  dynamic solution2;
  List<int> basePattern = [0, 1, 0, -1];

  Puzzle() {}

  List<String> parseInputByLine() {
    return input = inputFile.readAsStringSync().trim().split("\n");
  }

  List<String> parseInputBySeparator({String separator = ","}) {
    return input = inputFile.readAsStringSync().trim().split(separator);
  }

  void solve() {
    parseInputByLine();
    solution1 = calculateFFT(input[0], 100).substring(0,8);

    var offset = int.parse(input[0].substring(0, 7));
    var tail = input[0].substring(offset % input[0].length);

    var input2 = tail +
        [
          for (int i = 0;
              i <
                  (input[0].length * 10000 - offset - tail.length) ~/
                      input[0].length;
              i++)
            input[0]
        ].join();

    List<int> result = [];
    var count = 0;
    for (int phase = 0; phase < 100; phase++) {
      for (int i = 0; i < input2.length; i++) {
        count += int.parse(input2[i]);
      }

      // first one goes in as is
      result.add(count % 10);
      for (int j = 1; j < input2.length; j++) {
        count -= int.parse(input2[j - 1]);
        result.add(count % 10);
      }

      input2 = result.join();
      result.clear();
      count = 0;
    }

    solution2 = input2.substring(0, 8);  // 38673719 - x - too low
  }

  void solveTest() {
    var testInput = "99345678";
    calculateFFT(testInput, 30);
  }

  String calculateFFT(String input, int phaseCount) {
    List<int> result = [];
    var count = 0;
    for (int phase = 0; phase < phaseCount; phase++) {
      for (int i = 1; i <= input.length; i++) {
        var mask = generateMask(i, input.length);
        for (int j = 0; j < mask.length; j++) {
          count += mask[j] * int.parse(input[j]);
        }
        result.add((count).abs() % 10);
        count = 0;
      }

      //print("Phase $phase: ${result.join()}");
      input = result.join();
      result.clear();
    }
    return input;
  }

  List<int> generateMask(int index, int lengthOfInput) {
    var pattern =
        basePattern.expand((f) => [for (int i = 0; i < index; i++) f]).toList();
    return List.generate(
        lengthOfInput + 1, (index) => pattern[index % pattern.length])
      ..removeAt(0);
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
