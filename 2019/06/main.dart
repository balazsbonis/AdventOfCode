import 'dart:io';

class Puzzle {
  final inputFile = new File(".\\06\\input.txt");
  List<String> input = new List<String>();

  Puzzle() {}

  List<String> parseInputByLine() {
    return input = inputFile.readAsStringSync().trim().split("\n");
  }

  List<String> parseInputBySeparator({String separator = ","}) {
    return input = inputFile.readAsStringSync().trim().split(separator);
  }

  void solve(){

  }
}

void main() {
  Puzzle puzzle = new Puzzle();

  Stopwatch stopwatch = new Stopwatch();
  stopwatch.start();
  puzzle.solve();
  stopwatch.stop();
  
  print("Execution took ${stopwatch.elapsed}");
}