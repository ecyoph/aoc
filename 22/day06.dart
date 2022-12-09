import '../common.dart';

dynamic solveFor06_1(String input) {
  var chars = characters(input);
  for (var i = 0; i < chars.length - 3; i++) {
    if ({chars[i + 0], chars[i + 1], chars[i + 2], chars[i + 3]}.length == 4) {
      return i + 4;
    }
  }
}

dynamic solveFor06_2(String input) {
  var chars = characters(input);
  for (var i = 0; i < chars.length - 3; i++) {
    Set<String> cchars = {};
    for (int j = 0; j < 14; j++) {
      cchars.add(chars[i + j]);
    }

    if (cchars.length == 14) {
      return i + 14;
    }
  }
}

AOC addDay06({AOC? aoc = null}) {
  aoc = aoc == null ? AOC() : aoc;
  aoc
      .provideSolver("day06_1", solveFor06_1)
      .provideSolver("day06_2", solveFor06_2)
      .provideExpectedResult("day06_1_example", "7")
      .provideExpectedResult("day06_1_puzzle", "1625")
      .provideExpectedResult("day06_2_example", "19")
      .provideExpectedResult("day06_2_puzzle", "2250");
  return aoc;
}

void main() async {
  (await addDay06().solveAll()).printStats();
}
