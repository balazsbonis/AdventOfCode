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
    solution1 = calculateFFT(input[0], 100);
  }

  void solveTest() {
    var testInput = "12345678";
    calculateFFT(testInput, 4);
  }

  String calculateFFT(String input, int phaseCount){
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
