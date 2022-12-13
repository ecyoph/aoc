import 'dart:collection';

import '../common.dart';

void main() async {
  (await addDay12().solveAll()).printStats();
}

int shortestPath(int len, List<HashSet<int>> edges, HashSet<int> startingNodes,
    int endNode) {
  var inf = len + 10;
  List<int> nexts = [];
  HashSet<int> newNexts = HashSet();
  List<int> distLookup = List.filled(len, inf);
  for (var node in startingNodes) {
    distLookup[node] = 0;
    nexts.add(node);
  }

  List<bool> visited = List.filled(len, false);
  int newDist = 1;
  while (true) {
    if (nexts.isEmpty) {
      newDist++;
      nexts.addAll(newNexts);
      newNexts.clear();
      continue;
    }
    var next = nexts.removeLast();
    newNexts.remove(next);
    visited[next] = true;
    var targets = edges[next];
    for (var target in targets) {
      if (visited[target]) {
        continue;
      }
      if (target == endNode) {
        return newDist;
      }
      var tDist = distLookup[target];
      if (newDist < tDist) {
        newNexts.add(target);
      }
    }
  }
}

class Day12ParseResult {
  int len;
  HashSet<int> startingPoints;
  int endPoint;
  List<HashSet<int>> edges;
  Day12ParseResult(this.len, this.startingPoints, this.endPoint, this.edges);
}

Day12ParseResult parseDay12(String input, {bool part2 = false}) {
  var sCode = "S".codeUnitAt(0);
  var eCode = "E".codeUnitAt(0);
  var aCode = "a".codeUnitAt(0);
  var zCode = "z".codeUnitAt(0);
  var newSCode = -1;
  var newECode = -(zCode - aCode + 1);

  HashSet<int> startingPoints = HashSet();
  int endPoint = 0;
  var lines = splitLines(input);
  var xLen = lines[0].length;
  List<int> data = lines.expand((line) => line.codeUnits).toList();
  List<HashSet<int>> edges = List.generate(data.length, (_) => HashSet());
  void update(int i) {
    var x = data[i];
    if (x == sCode) {
      data[i] = newSCode;
    } else if (x == eCode) {
      data[i] = newECode;
    } else {
      data[i] = x - aCode + 1;
    }
  }

  void addStartEndPoint(int x, int i) {
    if ((part2 ? -(x.abs()) : x) == -1) {
      startingPoints.add(i);
    } else if (x == newECode) {
      endPoint = i;
    }
  }

  void addEdges(int x, int i, int i2) {
    var y = data[i2].abs();
    if (x.abs() - y > -2) {
      edges[i].add(i2);
    }
    if (y - x.abs() > -2) {
      edges[i2].add(i);
    }
  }

  var down = xLen - 1;
  var right = 0;
  var i = 0;
  var x = 0;
  update(0);
  for (; i < xLen - 1; i++) {
    down++;
    right++;
    update(right);
    update(down);
    x = data[i];
    addStartEndPoint(x, i);
    addEdges(x, i, right);
    addEdges(x, i, down);
  }
  down++;
  right++;
  update(down);
  x = data[i];
  addStartEndPoint(x, i);
  addEdges(x, i, down);
  i++;
  for (var j = xLen; j < data.length - xLen; j += xLen) {
    for (; i < j + xLen - 1; i++) {
      down++;
      right++;
      update(down);
      x = data[i];
      addStartEndPoint(x, i);
      addEdges(x, i, right);
      addEdges(x, i, down);
    }
    down++;
    right++;
    update(down);
    x = data[i];
    addStartEndPoint(x, i);
    addEdges(x, i, down);
    i++;
  }
  for (; i < data.length - 1; i++) {
    right++;
    x = data[i];
    addStartEndPoint(x, i);
    addEdges(x, i, right);
  }
  x = data[i];
  addStartEndPoint(x, i);
  return Day12ParseResult(data.length, startingPoints, endPoint, edges);
}

dynamic solveFor12_1(String input) {
  var g = parseDay12(input);
  return shortestPath(g.len, g.edges, g.startingPoints, g.endPoint);
}

dynamic solveFor12_2(String input) {
  var g = parseDay12(input, part2: true);
  return shortestPath(g.len, g.edges, g.startingPoints, g.endPoint);
}

AOC addDay12({AOC? aoc = null}) {
  aoc = aoc == null ? AOC() : aoc;
  aoc
      .provideSolver("day12_1", solveFor12_1)
      .provideSolver("day12_2", solveFor12_2)
      .provideExpectedResult("day12_1_example", "31")
      .provideExpectedResult("day12_1_puzzle", "528")
      .provideExpectedResult("day12_2_example", "29")
      .provideExpectedResult("day12_2_puzzle", "522");
  return aoc;
}
