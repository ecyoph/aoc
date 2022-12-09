import '../common.dart';

String solveFor04_1(String input) {
  var lines = splitLines(input);
  return sum(lines.map((line) {
    var ranges = line.split(",");
    var r1 = Tuple.fromIterable(parseInts(ranges[0].split("-")));
    var r2 = Tuple.fromIterable(parseInts(ranges[1].split("-")));
    if (r1.x >= r2.x && r1.y <= r2.y || r1.x <= r2.x && r1.y >= r2.y) {
      return 1;
    }
    return 0;
  })).toString();
}

String solveFor04_2(String input) {
  var lines = splitLines(input);
  return sum(lines.map((line) {
    var ranges = line.split(",");
    var r1 = Tuple.fromIterable(parseInts(ranges[0].split("-")));
    var r2 = Tuple.fromIterable(parseInts(ranges[1].split("-")));
    if (r1.x == r2.x ||
        r1.x < r2.x && r1.y >= r2.x ||
        r1.x > r2.x && r1.x <= r2.y) {
      return 1;
    }
    return 0;
  })).toString();
}

AOC addDay04({AOC? aoc = null}) {
  aoc = aoc == null ? AOC() : aoc;
  aoc
      .provideSolver("day04_1", solveFor04_1)
      .provideSolver("day04_2", solveFor04_2)
      .provideExpectedResult("day04_1_example", "2")
      .provideExpectedResult("day04_1_puzzle", "459")
      .provideExpectedResult("day04_2_example", "4")
      .provideExpectedResult("day04_2_puzzle", "779");
  return aoc;
}

void main() async {
  (await addDay04().solveAll()).printStats();
}
