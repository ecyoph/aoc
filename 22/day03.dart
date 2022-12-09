import '../common.dart';

dynamic solveFor03_1(String input) {
  var lines = splitLines(input);
  var bags = lines
      .map((line) => [
            line.codeUnits.sublist(0, line.length ~/ 2).toSet(),
            line.codeUnits.sublist(line.length ~/ 2).toSet()
          ])
      .toList();
  return sum(bags
      .map((e) => sum(e[0].intersection(e[1])))
      .map((e) => e >= 65 && e <= 90 ? e - 38 : e - 96)).toString();
}

dynamic solveFor03_2(String input) {
  var lines = splitLines(input);
  var bags = lines
      .map((line) => count(
          line.codeUnits.map((e) => e >= 65 && e <= 90 ? e - 38 : e - 96)))
      .toList();
  var groups = groupsOf(bags, 3);
  common(Map<int, int> x, Map<int, int> y, Map<int, int> z) {
    var c = x.keys
        .toSet()
        .intersection(y.keys.toSet())
        .intersection(z.keys.toSet())
        .first;
    return c;
  }

  return sum(groups.map((g) => apply(common, g))).toString();
}

AOC addDay03({AOC? aoc = null}) {
  aoc = aoc == null ? AOC() : aoc;
  aoc
      .provideSolver("day03_1", solveFor03_1)
      .provideSolver("day03_2", solveFor03_2)
      .provideExpectedResult("day03_1_example", "157")
      .provideExpectedResult("day03_1_puzzle", "7446")
      .provideExpectedResult("day03_2_example", "70")
      .provideExpectedResult("day03_2_puzzle", "2646");
  return aoc;
}

void main() async {
  (await addDay03().solveAll()).printStats();
}
