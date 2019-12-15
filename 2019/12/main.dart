import 'dart:io';
import '../base/handy_utils.dart';

class JovianMoon {
  int positionX, positionY, positionZ;
  int velocityX, velocityY, velocityZ;

  int get potential => positionX.abs() + positionY.abs() + positionZ.abs();
  int get kinetic => velocityX.abs() + velocityY.abs() + velocityZ.abs();
  int get totalEnergy => potential * kinetic;

  JovianMoon(this.positionX, this.positionY, this.positionZ) {
    velocityX = 0;
    velocityY = 0;
    velocityZ = 0;
  }

  @override
  String toString() {
    return "pos=<x=${positionX.toString().padLeft(4)},y=${positionY.toString().padLeft(4)},z=${positionZ.toString().padLeft(4)}>, vel=<x=${velocityX.toString().padLeft(4)},y=${velocityY.toString().padLeft(4)}z=${velocityZ.toString().padLeft(4)}, pot=$potential, kin=$kinetic, TOTAL=$totalEnergy>";
  }

  void calculateVelocity(List<JovianMoon> otherMoons) {
    for (var moon in otherMoons) {
      if (moon.positionX > this.positionX) {
        velocityX++;
      } else if (moon.positionX < this.positionX) {
        velocityX--;
      }
      if (moon.positionY > this.positionY) {
        velocityY++;
      } else if (moon.positionY < this.positionY) {
        velocityY--;
      }
      if (moon.positionZ > this.positionZ) {
        velocityZ++;
      } else if (moon.positionZ < this.positionZ) {
        velocityZ--;
      }
    }
  }

  void applyVelocity() {
    positionX += velocityX;
    positionY += velocityY;
    positionZ += velocityZ;
  }
}

class Puzzle {
  final inputFile = new File(".\\12\\input.txt");
  List<String> input = new List<String>();
  dynamic solution1;
  dynamic solution2;

  Puzzle() {}

  List<String> parseInputByLine() {
    return input = inputFile.readAsStringSync().trim().split("\n");
  }

  List<String> parseInputBySeparator({String separator = ","}) {
    return input = inputFile.readAsStringSync().trim().split(separator);
  }

  void solvePart1() {
    //<x=-15, y=1, z=4>
    // <x=1, y=-10, z=-8>
    // <x=-5, y=4, z=9>
    // <x=4, y=6, z=-2>
    var io = new JovianMoon(-15, 1, 4);
    var europa = new JovianMoon(1, -10, -8);
    var ganymede = new JovianMoon(-5, 4, 9);
    var callisto = new JovianMoon(4, 6, -2);

    for (int step = 0; step < 1000; step++) {
      io.calculateVelocity([europa, ganymede, callisto]);
      europa.calculateVelocity([io, ganymede, callisto]);
      ganymede.calculateVelocity([europa, io, callisto]);
      callisto.calculateVelocity([europa, ganymede, io]);
      io.applyVelocity();
      europa.applyVelocity();
      ganymede.applyVelocity();
      callisto.applyVelocity();
      print("STEP ${step}");
      print(io);
      print(europa);
      print(ganymede);
      print(callisto);
    }
    solution1 = io.totalEnergy +
        europa.totalEnergy +
        ganymede.totalEnergy +
        callisto.totalEnergy;
  }

  int solvePart2X() {
    //<x=-15, y=1, z=4>
    // <x=1, y=-10, z=-8>
    // <x=-5, y=4, z=9>
    // <x=4, y=6, z=-2>
    var ioX = new JovianMoon(-15, 0, 0);
    var europaX = new JovianMoon(1, 0, 0);
    var ganymedeX = new JovianMoon(-5, 0, 0);
    var callistoX = new JovianMoon(4, 0, 0);

    int step = 1;
    do {
      step++;
      ioX.calculateVelocity([europaX, ganymedeX, callistoX]);
      europaX.calculateVelocity([ioX, ganymedeX, callistoX]);
      ganymedeX.calculateVelocity([europaX, ioX, callistoX]);
      callistoX.calculateVelocity([europaX, ganymedeX, ioX]);
      ioX.applyVelocity();
      europaX.applyVelocity();
      ganymedeX.applyVelocity();
      callistoX.applyVelocity();
    } while (!(ioX.positionX == -15 &&
        europaX.positionX == 1 &&
        ganymedeX.positionX == -5 &&
        callistoX.positionX == 4));
    print("X: ${step}");
    return step;
  }

  int solvePart2Y() {
    //<x=-15, y=1, z=4>
    // <x=1, y=-10, z=-8>
    // <x=-5, y=4, z=9>
    // <x=4, y=6, z=-2>
    var ioX = new JovianMoon(0, 1, 0);
    var europaX = new JovianMoon(0, -10, 0);
    var ganymedeX = new JovianMoon(0, 4, 0);
    var callistoX = new JovianMoon(0, 6, 0);

    int step = 1;
    do {
      step++;
      ioX.calculateVelocity([europaX, ganymedeX, callistoX]);
      europaX.calculateVelocity([ioX, ganymedeX, callistoX]);
      ganymedeX.calculateVelocity([europaX, ioX, callistoX]);
      callistoX.calculateVelocity([europaX, ganymedeX, ioX]);
      ioX.applyVelocity();
      europaX.applyVelocity();
      ganymedeX.applyVelocity();
      callistoX.applyVelocity();
    } while (!(ioX.positionY == 1 &&
        europaX.positionY == -10 &&
        ganymedeX.positionY == 4 &&
        callistoX.positionY == 6));
    print("Y: ${step}");
    return step;
  }

  int solvePart2Z() {
    //<x=-15, y=1, z=4>
    // <x=1, y=-10, z=-8>
    // <x=-5, y=4, z=9>
    // <x=4, y=6, z=-2>
    var ioX = new JovianMoon(0, 0, 4);
    var europaX = new JovianMoon(0, 0, -8);
    var ganymedeX = new JovianMoon(0, 0, 9);
    var callistoX = new JovianMoon(0, 0, -2);

    int step = 1;
    do {
      step++;
      ioX.calculateVelocity([europaX, ganymedeX, callistoX]);
      europaX.calculateVelocity([ioX, ganymedeX, callistoX]);
      ganymedeX.calculateVelocity([europaX, ioX, callistoX]);
      callistoX.calculateVelocity([europaX, ganymedeX, ioX]);
      ioX.applyVelocity();
      europaX.applyVelocity();
      ganymedeX.applyVelocity();
      callistoX.applyVelocity();
    } while (!(ioX.positionZ == 4 &&
        europaX.positionZ == -8 &&
        ganymedeX.positionZ == 9 &&
        callistoX.positionZ == -2));
    print("Z: ${step}");
    return step;
  }

  void solveTest() {
    var io = new JovianMoon(-1, 0, 2);
    var europa = new JovianMoon(2, -10, -7);
    var ganymede = new JovianMoon(4, -8, 8);
    var callisto = new JovianMoon(3, 5, -1);

    for (int step = 0; step <= 9; step++) {
      io.calculateVelocity([europa, ganymede, callisto]);
      europa.calculateVelocity([io, ganymede, callisto]);
      ganymede.calculateVelocity([europa, io, callisto]);
      callisto.calculateVelocity([europa, ganymede, io]);
      io.applyVelocity();
      europa.applyVelocity();
      ganymede.applyVelocity();
      callisto.applyVelocity();
      print("STEP ${step}");
      print(io);
      print(europa);
      print(ganymede);
      print(callisto);
    }
    solution1 = io.totalEnergy +
        europa.totalEnergy +
        ganymede.totalEnergy +
        callisto.totalEnergy;
  }
}

void main() {
  Puzzle puzzle = new Puzzle();

  Stopwatch stopwatch = new Stopwatch();
  stopwatch.start();
  //puzzle.solvePart1();
  var xx = puzzle.solvePart2X();
  var yy = puzzle.solvePart2Y();
  var zz = puzzle.solvePart2Z();
  print(MathUtils.leastCommonMultiple(MathUtils.leastCommonMultiple(xx, yy),
      zz)); //5319532618758035 -x-too high
      // 332477126821644
      // 37324 -x-too low
      // 135915 -x-too low
  stopwatch.stop();

  print("Solution to part1: ${puzzle.solution1}");
  print("Solution to part2: ${puzzle.solution2}");
  print("Execution took ${stopwatch.elapsed}");
}
