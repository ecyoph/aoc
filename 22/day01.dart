import '../common.dart';

dynamic solveFor01_1(String input) {
  List<List<int>> data = smartParse<int>(input);
  return maxInList(data.map(sum));
}

dynamic solveFor01_2(String input) {
  List<List<int>> data = smartParse<int>(input);
  var calSums = mapToList(data, sum);
  calSums.sort(reverseCompareTo);
  return sum(calSums.sublist(0, 3));
}

AOC addDay01({AOC? aoc = null}) {
  aoc = aoc == null ? AOC() : aoc;
  aoc
      .provideSolver("day01_1", solveFor01_1)
      .provideSolver("day01_2", solveFor01_2)
      .provideExpectedResult("day01_1_example", "24000")
      .provideExpectedResult("day01_1_puzzle", "68775")
      .provideExpectedResult("day01_2_example", "45000")
      .provideExpectedResult("day01_2_puzzle", "202585");
  return aoc;
}

void main() async {
  (await addDay01().solveAll()).printStats();
}
