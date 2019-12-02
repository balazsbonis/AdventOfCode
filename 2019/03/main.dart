import 'dart:convert';
import 'dart:io';

class Puzzle{
  
  final inputFile = new File(".\\03\\input.txt");
  List<String> input = new List<String>();

  Puzzle() {

  }

  List<String> parseInputByLine(){
    return input = inputFile.readAsStringSync().trim().split("\n");
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