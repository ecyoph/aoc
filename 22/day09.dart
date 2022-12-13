import 'dart:collection';

import '../common.dart';

void main() async {
  (await addDay09().solveAll()).printStats();
}

int simRope(String input, int length) {
  var data = input
      .split("\n")
      .expand((line) =>
          List.filled(parseInt(line.substring(2)), line.codeUnitAt(0)))
      .toList();
  var rope = List.filled(length * 2, 0);
  int p(int a) => a.abs() * 2 + (a.sign >> 1) + 1; // convert a to positiv int
  int h(int x, int y) => (((x + y) * (x + y + 1)) >> 1) + y; // Cantor hash
  var pos = HashSet<int>(hashCode: identity<int>);
  pos.add(h(p(0), p(0)));
  for (var dir in data) {
    switch (dir) {
      case 85: //U
        rope[1]++;
        break;
      case 68: //D
        rope[1]--;
        break;
      case 82: //R
        rope[0]++;
        break;
      case 76: //L
        rope[0]--;
        break;
    }
    for (int i = 2; i < rope.length; i += 2) {
      var xHead = rope[i - 2];
      var yHead = rope[i - 1];
      var xTail = rope[i];
      var yTail = rope[i + 1];
      var yDist = yHead - yTail;
      var xDist = xHead - xTail;
      if (xDist.abs() | yDist.abs() > 1) {
        rope[i] += xDist.sign;
        rope[i + 1] += yDist.sign;
      }
    }
    pos.add(h(p(rope[rope.length - 2]), p(rope[rope.length - 1])));
  }
  return pos.length;
}

dynamic solveFor09_1(String input) {
  return simRope(input, 2);
}

dynamic solveFor09_2(String input) {
  return simRope(input, 10);
}

AOC addDay09({AOC? aoc = null}) {
  aoc = aoc == null ? AOC() : aoc;
  aoc
      .provideSolver("day09_1", solveFor09_1)
      .provideSolver("day09_2", solveFor09_2)
      .provideExpectedResult("day09_1_example", "13")
      .provideExpectedResult("day09_1_puzzle", "6498")
      .provideExpectedResult("day09_2_example", "1")
      .provideExpectedResult("day09_2_puzzle", "2531");
  return aoc;
}
