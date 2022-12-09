import '../common.dart';

void main() async {
  (await addDay09().solveAll()).printStats();
}

int simRope(String input, int length) {
  var data = smartParse(input)
      .expand((line) => List.filled(line[1], line[0]))
      .toList() as List;
  var rope = List.generate(length, (i) => Tuple<int, int>(0, 0));
  var pos = SetWith.fromIterable<Tuple<int, int>>(
      [Tuple<int, int>(0, 0)], (t) => t.x * data.length + t.y);
  for (var dir in data) {
    switch (dir) {
      case "U":
        rope[0].y++;
        break;
      case "D":
        rope[0].y--;
        break;
      case "R":
        rope[0].x++;
        break;
      case "L":
        rope[0].x--;
        break;
    }
    for (int i = 1; i < rope.length; i++) {
      var head = rope[i - 1];
      var tail = rope[i];
      var xHead = head.x;
      var yHead = head.y;
      var xTail = tail.x;
      var yTail = tail.y;
      var doY = (yHead - yTail).abs() > 1;
      var doX = (xHead - xTail).abs() > 1;
      var doX2 = doX || (xHead - xTail).abs() == 1 && doY;
      var doY2 = doY || (yHead - yTail).abs() == 1 && doX;
      if (doX2) {
        tail.x += (xHead - xTail) ~/ (xHead - xTail).abs();
      }
      if (doY2) {
        tail.y += (yHead - yTail) ~/ (yHead - yTail).abs();
      }
    }
    pos.add(rope.last);
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
