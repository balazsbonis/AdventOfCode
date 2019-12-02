import 'dart:convert';
import 'dart:io';

class Puzzle{
  
  final inputFile = new File(".\\02\\input.txt");
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
  var result = puzzle.parseInputBySeparator().map((String s) => int.parse(s)).toList();
  part1(result);
  print(result);

  // pt2
  part2(puzzle);
}

List<int> part1(List<int> result){
  int index = 0;
  int opcode;
  while (result[index] != 99){
    opcode = result[index];
    switch (opcode) {
      case 1:
        result[result[index+3]] = result[result[index+1]] + result[result[index+2]];
        break;
      case 2:
        result[result[index+3]] = result[result[index+1]] * result[result[index+2]];
        break;
      default:
        break;
    }
    index+=4;
  }
  return result;
}

List<int> part2(Puzzle puzzle){
  var originalArray = puzzle.parseInputBySeparator().map((String s) => int.parse(s)).toList();
  
  int noun = 0;
  int verb = 0;
  int result = 0;
  while (result != 19690720 && (noun != 100 && verb != 100)) {
    var currentArray = new List<int>.from(originalArray);
    currentArray[1] = noun;
    currentArray[2] = verb;
    result = part1(currentArray)[0];
    if (result == 19690720){
      print("$noun noun, $verb verb");
      print(currentArray);
    }
    verb++;
    if (verb == 100){
      verb = 1;
      noun++;
    }
  }
}