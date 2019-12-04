import 'dart:io';

class Puzzle {
  final inputFile = new File(".\\04\\input.txt");
  List<String> input = new List<String>();

  Puzzle() {}

  List<String> parseInputByLine() {
    return input = inputFile.readAsStringSync().trim().split("\n");
  }

  List<String> parseInputBySeparator({String separator = ","}) {
    return input = inputFile.readAsStringSync().trim().split(separator);
  }
}

void main() {
  Puzzle puzzle = new Puzzle();

  solve();
}

void solve() {
  var c = 206938;
  List<int> passwordsPt1 = new List<int>();
  List<int> passwordsPt2 = new List<int>();
  while (c <= 679128) {
    if (c ~/ 100000 > c % 100000 ~/ 10000) {
      // first digit larger than second
      c += 10000;
      c -= (c % 10000);
    } else if (c % 100000 ~/ 10000 > c % 10000 ~/ 1000) {
      // second > third
      c += 1000;
      c -= (c % 1000);
    } else if (c % 100000 % 10000 ~/ 1000 > c % 1000 ~/ 100) {
      // third > fourth
      c += 100;
      c -= (c % 100);      
    } else if (c % 100000 % 10000 % 1000 ~/ 100 > c % 100 ~/ 10) {
      // fourth > fifth
      c += 10;
      c -= (c % 10);
    } else if (c % 100000 % 10000 % 1000 % 100 ~/ 10 > c % 10) {
      c++;
    } else {
      if (checkForAdjacentSimilarities(c)) {
        passwordsPt1.add(c);
        if (checkForPart2(c)) {
          passwordsPt2.add(c);
          //print("!: ${c}");
        } else{
          //print(".: ${c}");
        }
      }
      c++;
    }
  }
  print("Count: ${passwordsPt1.length}");
  print("Count: ${passwordsPt2.length}");
}


bool checkForAdjacentSimilarities(int c) {
  var s = c.toString();
  return s[0] == s[1] ||
      s[1] == s[2] ||
      s[2] == s[3] ||
      s[3] == s[4] ||
      s[4] == s[5];
}

bool checkForPart2(int c) {
  var s = c.toString();
  return (s[0] == s[1] && s[1] != s[2]) ||
         (s[1] == s[2] && s[2] != s[3] && s[0] != s[1]) ||
         (s[2] == s[3] && s[3] != s[4] && s[1] != s[2]) ||
         (s[3] == s[4] && s[4] != s[5] && s[2] != s[3]) ||
         (s[4] == s[5] && s[4] != s[3]);
}
