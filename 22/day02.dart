import '../common.dart';

enum rpb {
  rock,
  paper,
  scissors,
}

enum outcome { win, lose, draw }

var lookup2 = {"X": outcome.lose, "Y": outcome.draw, "Z": outcome.win};

var values = {rpb.rock: 1, rpb.paper: 2, rpb.scissors: 3};

var winningAnser = {
  rpb.rock: rpb.paper,
  rpb.paper: rpb.scissors,
  rpb.scissors: rpb.rock
};

var losingAnswer = Map.fromIterable(winningAnser.entries,
    key: (e) => e.value, value: (e) => e.key);

int fight(rpb p1, rpb p2) {
  if (p1 == p2) {
    return 3 + values[p2]!;
  }

  if (winningAnser[p1] == p2) {
    return 6 + values[p2]!;
  }

  return values[p2]!;
}

rpb convert(rpb p1, outcome o) {
  if (o == outcome.win) {
    return winningAnser[p1]!;
  } else if (o == outcome.lose) {
    return losingAnswer[p1]!;
  }
  return p1;
}

var lookup = {
  "A": rpb.rock,
  "X": rpb.rock,
  "B": rpb.paper,
  "Y": rpb.paper,
  "C": rpb.scissors,
  "Z": rpb.scissors
};

dynamic solveFor02_1(String input) {
  List<List<String>> data = smartParse<String>(input);
  return sum(data.map((p) => fight(lookup[p[0]]!, lookup[p[1]]!)));
}

dynamic solveFor02_2(String input) {
  List<List<String>> data = smartParse<String>(input);
  return sum(data.map(
      (p) => fight(lookup[p[0]]!, convert(lookup[p[0]]!, lookup2[p[1]]!))));
}

AOC addDay02({AOC? aoc = null}) {
  aoc = aoc == null ? AOC() : aoc;
  aoc
      .provideSolver("day02_1", solveFor02_1)
      .provideSolver("day02_2", solveFor02_2)
      .provideExpectedResult("day02_1_example", "15")
      .provideExpectedResult("day02_1_puzzle", "13052")
      .provideExpectedResult("day02_2_example", "12")
      .provideExpectedResult("day02_2_puzzle", "13693");
  return aoc;
}

void main() async {
  (await addDay02().solveAll()).printStats();
}
