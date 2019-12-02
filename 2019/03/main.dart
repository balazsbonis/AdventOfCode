import 'dart:convert';
import 'dart:io';

class Puzzle{
  
  final inputFile = new File(".\\03\\input.txt");
  List<String> input = new List<String>();

  Puzzle() {

  }

  List<String> parseInputByLine(){
    Stream<List<int>> inputStream = inputFile.openRead();
    input.clear();
    inputStream
      .transform(utf8.decoder)
      .transform(new LineSplitter())
      .listen((String line) => input.add(line),
         onError: (e) { print("Something went wrong: $e)"); }
      )
    ;
    return input;
  }

  List<String> parseInputBySeparator({String separator = ","}){
    return input = inputFile.readAsStringSync().trim().split(separator);
  }
}

void main(){
  Puzzle puzzle = new Puzzle();  
  
  // pt1
  part1(puzzle);

  // pt2
  part2(puzzle);
}

void part1(Puzzle puzzle){
}

void part2(Puzzle puzzle){
}