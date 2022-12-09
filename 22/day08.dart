import '../common.dart';

void main() async {
  (await addDay08().solveAll()).printStats();
}

dynamic solveFor08_1(String input) {
  var lines = splitLines(input);
  var xlen = lines[0].length;
  var ylen = lines.length;
  var data = lines.join("").codeUnits;
  var v = List.filled(data.length, false);
  var big = -1;
  var cur = -1;
  var bigger = false;
  var ly = (ylen - 1) * xlen;
  for (int x = 0; x < xlen; x++) {
    v[x] = true;
    v[x + ly] = true;
  }
  for (int y = xlen; y < ly; y += xlen) {
    v[y] = true;
    v[y + xlen - 1] = true;
    big = data[y];
    for (int x = 1; x < xlen - 1; x++) {
      cur = data[y + x];
      bigger = cur > big;
      if (bigger) {
        big = cur;
        v[y + x] = true;
      }
    }
  }

  for (int y = xlen; y < ly; y += xlen) {
    big = data[y + xlen - 1];
    for (int x = xlen - 2; x > 0; x--) {
      cur = data[y + x];
      bigger = cur > big;
      if (bigger) {
        big = cur;
        v[y + x] = true;
      }
    }
  }

  for (int x = 1; x < xlen - 1; x++) {
    big = data[x];
    for (int y = xlen; y < ly; y += xlen) {
      cur = data[y + x];
      bigger = cur > big;
      if (bigger) {
        big = cur;
        v[y + x] = true;
      }
    }
  }

  for (int x = 1; x < xlen - 1; x++) {
    big = data[x + ly];
    for (int y = ly - xlen; y > 0; y -= xlen) {
      cur = data[y + x];
      bigger = cur > big;
      if (bigger) {
        big = cur;
        v[y + x] = true;
      }
    }
  }

  return v.fold<int>(0, (i, b) => b ? i + 1 : i);
}

dynamic solveFor08_2(String input) {
  var lines = splitLines(input);
  var xlen = lines[0].length;
  var ylen = lines.length;
  var data = lines.join("").codeUnits;
  var v = List.filled(data.length, 1);
  var big = -1;
  var big2 = -1;
  var cur = -1;
  var cur2 = -1;
  var bigger = false;
  var bigger2 = false;
  var x2 = 0;
  var y2 = 0;
  int i = 0;
  var ly = (ylen - 1) * xlen;
  for (int y = xlen; y < ly; y += xlen) {
    y2 = y + xlen - 1;
    big = data[y];
    big2 = data[y2];
    for (int x = 1; x < xlen - 1; x++) {
      cur = data[y + x];
      cur2 = data[y2 - x];
      bigger = cur > big;
      bigger2 = cur2 > big2;
      if (bigger) {
        v[y + x] *= x;
        big = cur;
      } else {
        for (i = 1; i <= x; i++) {
          if (data[y + x - i] >= cur) {
            v[y + x] *= i;
            break;
          }
        }
      }
      if (bigger2) {
        v[y2 - x] *= x;
        big2 = cur2;
      } else {
        for (i = 1; i <= x; i++) {
          if (data[y2 - x + i] >= cur2) {
            v[y2 - x] *= i;
            break;
          }
        }
      }
    }
  }

  for (int x = 1; x < xlen - 1; x++) {
    x2 = ly + x;
    big = data[x];
    big2 = data[x2];
    for (int y = xlen; y < ly; y += xlen) {
      cur = data[x + y];
      cur2 = data[x2 - y];
      bigger = cur > big;
      bigger2 = cur2 > big2;
      if (bigger) {
        v[x + y] *= y ~/ xlen;
        big = cur;
      } else {
        for (i = xlen; i <= y; i += xlen) {
          if (data[x + y - i] >= cur) {
            v[x + y] *= i ~/ xlen;
            break;
          }
        }
      }
      if (bigger2) {
        v[x2 - y] *= y ~/ xlen;
        big2 = cur2;
      } else {
        for (i = xlen; i <= y; i += xlen) {
          if (data[x2 - y + i] >= cur2) {
            v[x2 - y] *= i ~/ xlen;
            break;
          }
        }
      }
    }
  }

  return maxInList(v);
}

AOC addDay08({AOC? aoc = null}) {
  aoc = aoc == null ? AOC() : aoc;
  aoc
      .provideSolver("day08_1", solveFor08_1)
      .provideSolver("day08_2", solveFor08_2)
      .provideExpectedResult("day08_1_example", "21")
      .provideExpectedResult("day08_1_puzzle", "1719")
      .provideExpectedResult("day08_2_example", "8")
      .provideExpectedResult("day08_2_puzzle", "590824");
  return aoc;
}
