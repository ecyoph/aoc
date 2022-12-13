import 'dart:collection';

import '../common.dart';

dynamic solveFor03_1(String input) {
  var lines = splitLines(input);
  var bags = lines
      .map((line) => [
            HashSet.from(line.codeUnits.sublist(0, line.length ~/ 2)),
            HashSet.from(line.codeUnits.sublist(line.length ~/ 2))
          ])
      .toList();
  return sum(bags
      .map((e) => e[0].intersection(e[1]).first)
      .map((e) => e >= 65 && e <= 90 ? e - 38 : e - 96)).toString();
}

dynamic solveFor03_2(String input) {
  var lines = splitLines(input);
  var bags = lines
      .map((line) => count(
          line.codeUnits.map((e) => e >= 65 && e <= 90 ? e - 38 : e - 96)))
      .toList();
  var groups = groupsOf(bags, 3);
  int common(List<HashMap<int, int>> x) {
    var c = HashSet.from(x[0].keys)
        .intersection(HashSet.from(x[1].keys))
        .intersection(HashSet.from(x[2].keys))
        .first;
    return c;
  }

  return sum(groups.map(common)).toString();
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
