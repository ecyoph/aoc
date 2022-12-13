import '../common.dart';

int classifyPacketElement(String x) {
  if (x == "[") {
    return 1;
  } else if (x == "]") {
    return 2;
  }
  return 0;
}

int comparePackets(List<String> packet1, List<String> packet2) {
  var l1Off = 0;
  var l2Off = 0;
  var l1Tmp = <String>[];
  var l2Tmp = <String>[];
  var len = packet1.length;
  for (int j = 0; j - l1Off < len; j++) {
    String el1;
    if (l1Tmp.isEmpty) {
      el1 = packet1[j - l1Off];
    } else {
      el1 = l1Tmp.removeLast();
    }
    String el2;
    if (l2Tmp.isEmpty) {
      el2 = packet2[j - l2Off];
    } else {
      el2 = l2Tmp.removeLast();
    }
    var c1 = classifyPacketElement(el1);
    var c2 = classifyPacketElement(el2);
    if (c1 == 1) {
      if (c2 == 2) {
        return 1;
      }
      if (c2 == 1) {
        continue;
      }
      l2Tmp.add("]");
      l2Tmp.add(el2);
      l2Off += 2;
      continue;
    }
    if (c1 == 2) {
      if (c2 == 2) {
        continue;
      }
      return -1;
    }
    if (c1 == 0) {
      if (c2 == 2) {
        return 1;
      }
      if (c2 == 1) {
        l1Tmp.add("]");
        l1Tmp.add(el1);
        l1Off += 2;
        continue;
      }
      var v1 = parseInt(el1);
      var v2 = parseInt(el2);
      if (v1 < v2) {
        return -1;
      }
      if (v1 > v2) {
        return 1;
      }
      continue;
    }
  }
  return 0;
}

dynamic solveFor13_1(String input) {
  var re = RegExp(r'(\[)|(\])|(\d+)');
  var data = input
      .split("\n\n")
      .map((group) => splitLines(group)
          .map((line) => re
              .allMatches(line)
              .map((match) => line.substring(match.start, match.end))
              .toList())
          .toList())
      .toList();

  var sum = 0;
  for (int i = 0; i < data.length; i++) {
    var group = data[i];
    var line1 = group[0];
    var line2 = group[1];
    if (comparePackets(line1, line2) <= 0) {
      sum += i + 1;
    }
  }
  return sum;
}

dynamic solveFor13_2(String input) {
  var re = RegExp(r'(\[)|(\])|(\d+)');
  var data = splitLines(input.replaceAll("\n\n", "\n"))
      .map((line) => re
          .allMatches(line)
          .map((match) => line.substring(match.start, match.end))
          .toList())
      .toList();

  var d1 = ["[", "[", "2", "]", "]"];
  var d2 = ["[", "[", "6", "]", "]"];
  data.add(d1);
  data.add(d2);

  data.sort(comparePackets);
  return (data.indexOf(d1) + 1) * (data.indexOf(d2) + 1);
}

void main() async {
  (await addDay13().solveAll()).printStats();
}

AOC addDay13({AOC? aoc = null}) {
  aoc = aoc == null ? AOC() : aoc;
  aoc
      .provideSolver("day13_1", solveFor13_1)
      .provideSolver("day13_2", solveFor13_2)
      .provideExpectedResult("day13_1_example", "13")
      .provideExpectedResult("day13_1_puzzle", "5682")
      .provideExpectedResult("day13_2_example", "140")
      .provideExpectedResult("day13_2_puzzle", "20304");
  return aoc;
}
