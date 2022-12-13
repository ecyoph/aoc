import 'dart:collection';

import '../common.dart';

void main() async {
  (await addDay10().solveAll()).printStats();
}

dynamic solveFor10_1(String input) {
  var prog = input
      .split("\n")
      .expand((l) => [0] + (l.length > 4 ? [int.parse(l.substring(5))] : []))
      .toList();

  var targets = HashSet.from([19, 59, 99, 139, 179, 219]);
  var x = 1, s = 0;
  for (int i = 0; i < 220; i++) {
    if (targets.contains(i)) {
      s += x * (i + 1);
    }
    x += prog[i % prog.length];
  }
  return s;
}

dynamic solveFor10_2(String input) {
  var prog = input
      .split("\n")
      .expand((l) => [0] + (l.length > 4 ? [int.parse(l.substring(5))] : []))
      .toList();
  var x = 1, out = "";
  for (int i = 0, j = 0; i < 240; j = ++i % 40) {
    out += (j == 0 && i > 0 ? "\n" : "") + ((j - x).abs() < 2 ? "#" : ".");
    x += prog[i % prog.length];
  }
  return "${out.hashCode} (hash)";
}

AOC addDay10({AOC? aoc = null}) {
  aoc = aoc == null ? AOC() : aoc;
  aoc
      .provideSolver("day10_1", solveFor10_1)
      .provideSolver("day10_2", solveFor10_2)
      .provideExpectedResult("day10_1_example", "13140")
      .provideExpectedResult("day10_1_puzzle", "13440")
      .provideExpectedResult("day10_2_example", "119660505 (hash)")
      .provideExpectedResult("day10_2_puzzle", "855010052 (hash)");
  return aoc;
}
