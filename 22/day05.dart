import '../common.dart';

dynamic solveFor05_1(String input) {
  var hints1 = Hints();
  hints1.atomSeparator = RegExp(r'(?<=^(...\s)*...)\s(?=.*...$)');
  hints1.onAtom = (atom) => atom.substring(1, 2);
  hints1.beforeLines = (lines) => lines.substring(0, lines.lastIndexOf("\n"));
  var hints2 = Hints();
  hints2.beforeLine = (line) => line.substring(5);
  hints2.atomSeparator = RegExp(r'( from )|( to )');
  var data = smartParse(input, groupHints: [hints1, hints2]);
  var stackMatrix = asList2<String>(data[0]);
  var stacks = mapToList<List<String>, List<String>>(transpose(stackMatrix),
      (x) => also(x.reversed.toList(), (x) => x.retainWhere((s) => s != " ")));
  var instructions = asList2<int>(data[1]);
  instructions = mapToList<List<int>, List<int>>(
      instructions, (x) => [x[0], x[1] - 1, x[2] - 1]);
  for (var instruction in instructions) {
    var from = instruction[1];
    var to = instruction[2];
    var amount = instruction[0];
    var elems = List.generate(amount, (_) => stacks[from].removeLast());
    stacks[to].addAll(elems);
  }
  return mapToList<List<String>, String>(stacks, (stack) => stack.last)
      .join("");
}

String solveFor05_2(String input) {
  var hints1 = Hints();
  hints1.atomSeparator = RegExp(r'(?<=^(...\s)*...)\s(?=.*...$)');
  hints1.onAtom = (atom) => atom.substring(1, 2);
  hints1.beforeLines = (lines) => lines.substring(0, lines.lastIndexOf("\n"));
  var hints2 = Hints();
  hints2.beforeLine = (line) => line.substring(5);
  hints2.atomSeparator = RegExp(r'( from )|( to )');
  var data = smartParse(input, groupHints: [hints1, hints2]);
  var stackMatrix = asList2<String>(data[0]);
  var stacks = mapToList<List<String>, List<String>>(transpose(stackMatrix),
      (x) => also(x.reversed.toList(), (x) => x.retainWhere((s) => s != " ")));
  var instructions = asList2<int>(data[1]);
  instructions = mapToList<List<int>, List<int>>(
      instructions, (x) => [x[0], x[1] - 1, x[2] - 1]);
  for (var instruction in instructions) {
    var from = instruction[1];
    var to = instruction[2];
    var amount = instruction[0];
    var elems = List.generate(amount, (_) => stacks[from].removeLast())
        .reversed
        .toList();
    stacks[to].addAll(elems);
  }
  return mapToList<List<String>, String>(stacks, (stack) => stack.last)
      .join("");
}

AOC addDay05({AOC? aoc = null}) {
  aoc = aoc == null ? AOC() : aoc;
  aoc
      .provideSolver("day05_1", solveFor05_1)
      .provideSolver("day05_2", solveFor05_2)
      .provideExpectedResult("day05_1_example", "CMZ")
      .provideExpectedResult("day05_1_puzzle", "TPGVQPFDH")
      .provideExpectedResult("day05_2_example", "MCD")
      .provideExpectedResult("day05_2_puzzle", "DMRDFRHHH");
  return aoc;
}

void main() async {
  (await addDay05().solveAll()).printStats();
}
