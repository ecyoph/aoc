import '../common.dart';

class Monkey {
  int inspectionsCount = 0;
  int id;
  List<int> items;
  int Function(int) operation;
  int divisor;
  int trueMonkeyId;
  int falseMonkeyId;

  Monkey(this.id, this.items, this.operation, this.divisor, this.trueMonkeyId,
      this.falseMonkeyId);

  static Monkey fromLines(String input) {
    var lines = splitLines(input);
    var id = parseInt(lines[0].substring(7, lines[0].length - 1));
    var startingItems = parseInts(lines[1].substring(18).split(", "));
    var operation = parseOperation(lines[2].substring(19));
    var divisor = parseInt(lines[3].substring(21));
    var rule1 = lines[4].substring(7);
    var rule2 = lines[5].substring(7);
    if (rule1.startsWith("false")) {
      var tmpRule = rule1;
      rule1 = rule2;
      rule2 = tmpRule;
    }
    var trueMonkeyId = parseInt(rule1.split(" ").last);
    var falseMonkeyId = parseInt(rule2.split(" ").last);
    return Monkey(
        id, startingItems, operation, divisor, trueMonkeyId, falseMonkeyId);
  }

  @override
  String toString() {
    return "id = $id, items = $items";
  }
}

int Function(int) parseOperation(String opStr) {
  List<String> parts;
  bool add = true;
  if (opStr.contains("*")) {
    add = false;
    parts = opStr.split(" * ");
  } else {
    parts = opStr.split(" + ");
  }
  var op = add ? (x, y) => x + y : (x, y) => x * y;
  if (parts[0] == "old" && parts[1] == "old") {
    return (x) => op(x, x);
  } else if (parts[0] == "old") {
    return (x) => op(x, parseInt(parts[1]));
  } else if (parts[1] == "old") {
    return (x) => op(parseInt(parts[0]), x);
  } else {
    return (x) => op(parseInt(parts[0]), parseInt(parts[1]));
  }
}

dynamic solveFor11_1(String input) {
  List<Monkey> data =
      input.split("\n\n").map((lines) => Monkey.fromLines(lines)).toList();
  for (int i = 0; i < 20; i++) {
    for (var m in data) {
      var len = m.items.length;
      m.inspectionsCount += len;
      for (var j = 0; j < len; j++) {
        var it = m.operation(m.items.removeAt(0)) ~/ 3;
        data[it % m.divisor == 0 ? m.trueMonkeyId : m.falseMonkeyId]
            .items
            .add(it);
      }
    }
  }
  var ins = data.map<int>((m) => m.inspectionsCount).toList();
  ins.sort(reverseCompareTo);
  return ins[0] * ins[1];
}

dynamic solveFor11_2(String input) {
  List<Monkey> data =
      input.split("\n\n").map((lines) => Monkey.fromLines(lines)).toList();
  var x = lcm(data.map((m) => m.divisor).toList());
  var len = sum(data.map((m) => m.items.length));
  var allDataLen = len + 7;
  var allDataTotalLen = allDataLen * data.length;
  List<List<int>> ops = input.split("\n\n").map((lines) {
    var line = lines.split("\n")[2];
    var elems = line.split(" ");
    elems = elems.sublist(elems.length - 3, elems.length);
    var e1 = elems[0];
    var e2 = elems[2];
    var op = elems[1];
    if (e2 == "old") {
      var tmp = e1;
      e1 = e2;
      e2 = e1;
    }
    if (op == "*") {
      if (e2 == "old") {
        return [0, 1];
      } else {
        return [parseInt(e2), 2];
      }
    } else {
      if (e2 == "old") {
        return [0, 3];
      } else {
        return [parseInt(e2), 4];
      }
    }
  }).toList();
  int itemCountOff = 0;
  int inspectionCountOff = 1;
  int tmIdOff = 2;
  int fmIdOff = 3;
  int divOff = 4;
  int opNumOff = 5;
  int opOff = 6;
  int itemsOff = 7;
  List<int> allData = List.filled(allDataTotalLen, 0, growable: false);
  for (int i = 0; i < data.length; i++) {
    var start = i * allDataLen;
    var m = data[i];
    allData[start + itemCountOff] = m.items.length;
    for (int j = 0; j < m.items.length; j++) {
      allData[start + itemsOff + j] = m.items[j];
    }
    allData[start + tmIdOff] = m.trueMonkeyId;
    allData[start + fmIdOff] = m.falseMonkeyId;
    allData[start + divOff] = m.divisor;
    allData[start + opNumOff] = ops[i][0];
    allData[start + opOff] = ops[i][1];
  }
  for (int i = 0; i < 10000; i++) {
    for (int y = 0; y < data.length; y++) {
      var start = allDataLen * y;
      var other = allData[start + opNumOff];
      var op = allData[start + opOff];
      var trueMonkeyId = allData[start + tmIdOff];
      var falseMonkeyId = allData[start + fmIdOff];
      var divisor = allData[start + divOff];
      int j = 0;
      int itemCount = allData[start + itemCountOff];
      switch (op) {
        case 1:
          for (; j < itemCount; j++) {
            int it = allData[start + itemsOff + j];
            it = (it * it) % x;
            var mId = it % divisor == 0 ? trueMonkeyId : falseMonkeyId;
            int otherStart = mId * allDataLen;
            allData[otherStart +
                itemsOff +
                allData[otherStart + itemCountOff]] = it;
            allData[otherStart + itemCountOff]++;
          }
          break;
        case 2:
          for (; j < itemCount; j++) {
            int it = allData[start + itemsOff + j];
            it = (it * other) % x;
            var mId = it % divisor == 0 ? trueMonkeyId : falseMonkeyId;
            int otherStart = mId * allDataLen;
            allData[otherStart +
                itemsOff +
                allData[otherStart + itemCountOff]] = it;
            allData[otherStart + itemCountOff]++;
          }
          break;
        case 3:
          for (; j < itemCount; j++) {
            int it = allData[start + itemsOff + j];
            it = (it + it) % x;
            var mId = it % divisor == 0 ? trueMonkeyId : falseMonkeyId;
            int otherStart = mId * allDataLen;
            allData[otherStart +
                itemsOff +
                allData[otherStart + itemCountOff]] = it;
            allData[otherStart + itemCountOff]++;
          }
          break;
        case 4:
          for (; j < itemCount; j++) {
            int it = allData[start + itemsOff + j];
            it = (it + other) % x;
            var mId = it % divisor == 0 ? trueMonkeyId : falseMonkeyId;
            int otherStart = mId * allDataLen;
            allData[otherStart +
                itemsOff +
                allData[otherStart + itemCountOff]] = it;
            allData[otherStart + itemCountOff]++;
          }
          break;
      }
      allData[start + itemCountOff] = 0;
      allData[start + inspectionCountOff] += j;
    }
  }
  var inspectionCounts = List.generate(
      data.length, (i) => allData[i * allDataLen + inspectionCountOff]);
  inspectionCounts.sort(reverseCompareTo);
  return inspectionCounts[0] * inspectionCounts[1];
}

void main() async {
  (await addDay11().solveAll()).printStats();
}

AOC addDay11({AOC? aoc = null}) {
  aoc = aoc == null ? AOC() : aoc;
  aoc
      .provideSolver("day11_1", solveFor11_1)
      .provideSolver("day11_2", solveFor11_2)
      .provideExpectedResult("day11_1_example", "10605")
      .provideExpectedResult("day11_1_puzzle", "110264")
      .provideExpectedResult("day11_2_example", "2713310158")
      .provideExpectedResult("day11_2_puzzle", "23612457316");
  return aoc;
}
