import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

String formatMicroseconds(int us) {
  return us.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},') +
      "us";
}

String formatDay(int day) {
  return "day" + (day < 10 ? "0" : "") + day.toString();
}

Future<Map> getDay(int day) async {
  var inputsJson = await File("inputs.json").readAsString();
  var map = jsonDecode(inputsJson);
  return map[formatDay(day)];
}

Future<String> getExample(int day) async {
  return (await getDay(day))["example1"] as String;
}

Future<String> getPuzzle(int day) async {
  return (await getDay(day))["puzzle1"] as String;
}

class AOC {
  Map<String, dynamic Function(String)> solvers = {};
  Map<String, String> expectedResults = {};
  Map<String, int> times = {};

  AOC provideSolver(String id, dynamic Function(String) solver) {
    solvers[id] = solver;
    return this;
  }

  AOC provideExpectedResult(String id, String result) {
    if (result != "") {
      expectedResults[id] = result;
    }
    return this;
  }

  Future<AOC> solveAll(
      {bool solvePuzzles = true,
      bool solveExamples = true,
      int repetitions = 1}) async {
    var solverEntries = solvers.entries.toList();
    solverEntries.sort((e1, e2) => e1.key.compareTo(e2.key));
    var stopwatch = Stopwatch();
    var inputsJson = await File("inputs.json").readAsString();
    var inputs = jsonDecode(inputsJson);

    for (var solver in solverEntries) {
      var id = solver.key;
      var formattedDay = id.substring(0, 5);
      var day = int.parse(id.substring(3, 5));
      var part = int.parse(id.substring(6));

      if (solveExamples) {
        String exampleInput = inputs[formattedDay]["example1"];
        var exampleTimes = <int>[];
        var exampleResult;
        for (int r = 0; r < repetitions; r++) {
          stopwatch.start();
          exampleResult = solver.value(exampleInput).toString();
          stopwatch.stop();
          exampleTimes.add(stopwatch.elapsedMicroseconds);
          stopwatch.reset();
        }
        var expectedExampleResult = expectedResults["${id}_example"];

        if (expectedExampleResult != null) {
          if (expectedExampleResult == exampleResult) {
            exampleResult = "✅ $exampleResult";
          } else {
            exampleResult =
                "❌ $exampleResult (expected $expectedExampleResult)";
          }
        }
        var exampleTime = sum(exampleTimes) ~/ exampleTimes.length;
        provideExampleResult(day, part, exampleResult, exampleTime);
        times["${id}_example"] = exampleTime;
      }

      if (solvePuzzles) {
        String puzzleInput = inputs[formattedDay]["puzzle1"];
        var puzzleTimes = <int>[];
        var puzzleResult;
        for (int r = 0; r < repetitions; r++) {
          stopwatch.start();
          puzzleResult = solver.value(puzzleInput).toString();
          stopwatch.stop();
          puzzleTimes.add(stopwatch.elapsedMicroseconds);
          stopwatch.reset();
        }

        var expectedPuzzleResult = expectedResults["${id}_puzzle"];

        if (expectedPuzzleResult != null) {
          if (expectedPuzzleResult == puzzleResult) {
            puzzleResult = "✅ $puzzleResult";
          } else {
            puzzleResult = "❌ $puzzleResult (expected $expectedPuzzleResult)";
          }
        }
        var puzzleTime = sum(puzzleTimes) ~/ puzzleTimes.length;
        providePuzzleResult(day, part, puzzleResult, puzzleTime);
        times["${id}_puzzle"] = puzzleTime;
      }
    }
    return this;
  }

  AOC printStats() {
    print("\nTotal time: ${formatMicroseconds(sum(times.values))}");
    var timeEntries = times.entries.toList();
    timeEntries.sort((a, b) => b.value.compareTo(a.value));

    if (times.length > 4) {
      print("Slowest solutions:");
      for (var i = 0; i < 5; i++) {
        var timeEntry = timeEntries[i];
        print("${timeEntry.key}: ${formatMicroseconds(timeEntry.value)}");
      }
    }
    return this;
  }
}

void provideExampleResult(int day, int part, String result, int microseconds) {
  print(
      "${formatDay(day)} part $part, example result (${formatMicroseconds(microseconds)}):\n$result");
}

void provideExampleResult1(int day, String result) {
  provideExampleResult(day, 1, result, 0);
}

void provideExampleResult2(int day, String result) {
  provideExampleResult(day, 2, result, 0);
}

void providePuzzleResult(int day, int part, String result, int microseconds) {
  print(
      "${formatDay(day)} part $part, puzzle result (${formatMicroseconds(microseconds)}):\n$result");
}

void providePuzzleResult1(int day, String result) {
  providePuzzleResult(day, 1, result, 0);
}

void providePuzzleResult2(int day, String result) {
  providePuzzleResult(day, 2, result, 0);
}

class Box<T> {
  T value;
  Box(this.value);
}

List<String> splitLines(String str) {
  return str.split("\n");
}

List<String> splitWhitespaces(String str) {
  return str.split(" ");
}

List<String> splitMultiWhitespaces(String str) {
  return str.split(RegExp(r'\s+'));
}

List<String> splitCommas(String str) {
  return str.split(",");
}

List<List<String>> groupOnEmptyLine(List<String> lines) {
  List<List<String>> groups = [];
  if (lines.isNotEmpty) {
    groups.add([]);
  }

  for (var line in lines) {
    if (line.isEmpty) {
      groups.add([]);
    } else {
      groups[groups.length - 1].add(line);
    }
  }

  return groups;
}

List<List<T>> groupsOf<T>(List<T> list, int size) {
  if (list.length <= size) {
    return [list];
  }
  var rest = groupsOf(list.sublist(size), size);
  rest.insert(0, list.sublist(0, size));
  return rest;
}

List<List<T>> group<T>(List<T> list) {
  if (list.isEmpty) {
    return [];
  }

  var ce = list[0];
  var ll = [ce];
  List<List<T>> groups = [ll];
  for (var elem in list.sublist(1)) {
    if (elem == ce) {
      ll.add(elem);
    } else {
      ce = elem;
      ll = [elem];
      groups.add(ll);
    }
  }

  return groups;
}

List<List<T>> transpose<T>(List<List<T>> matrix) {
  if (matrix.isEmpty) {
    return [];
  }

  var len = matrix[0].length;

  List<List<T>> transposed = List.generate(len, (index) => []);

  for (var vec in matrix) {
    for (var i = 0; i < len; i++) {
      transposed[i].add(vec[i]);
    }
  }

  return transposed;
}

int sum(Iterable<int> nums) {
  return nums.fold<int>(0, (a, b) => a + b);
}

int mul(Iterable<int> nums) {
  return nums.fold<int>(1, (a, b) => a * b);
}

List<int> parseInts(Iterable<String> intStrs) {
  return intStrs.map<int>((v) => int.parse(v)).toList();
}

Map<T, int> count<T>(Iterable<T> elems) {
  var counts = <T, int>{};

  for (var elem in elems) {
    counts.update(elem, (count) => count + 1, ifAbsent: () => 1);
  }

  return counts;
}

T maxInList<T>(Iterable<T> elems) {
  HashSet<dynamic> vs = HashSet.from(elems);
  dynamic maxV = vs.first;

  for (var v in vs) {
    if (v > maxV) {
      maxV = v;
    }
  }

  return maxV;
}

T minInList<T>(Iterable<T> elems) {
  HashSet<dynamic> vs = HashSet.from(elems);
  dynamic minV = vs.first;

  for (var v in vs) {
    if (v < minV) {
      minV = v;
    }
  }

  return minV;
}

bool setEquals<T>(Set<T> x, Set<T> y) {
  return x.length == y.length && x.containsAll(y);
}

int power(int base, int exp) {
  return exp == 0 ? 1 : base * power(base, exp - 1);
}

class CellularAutomation {}

abstract class Matrix<T> {
  List<int> getShape();
  T get(List<int> index);
  List<T> getRange(List<int> index, int rangeStart, int rangeEnd);
  List<T> getData();
}

class MatrixView<T> implements Matrix<T> {
  Matrix<T> source;
  List<int> shape;
  List<int> offset;
  T? defaultValue;

  MatrixView(this.source, this.shape, this.offset, this.defaultValue);

  List<int> getShape() {
    return shape;
  }

  List<T> getRange(List<int> index, int rangeStart, int rangeEnd) {
    int ii = 0;
    for (int i = 0; i < index.length; i++) {
      if (index[i] < 0) {
        ii = i;
        break;
      }
    }
    var v = <T>[];
    var preCount = max(0, -(offset[ii] + rangeStart));
    var postCount = max(0, -(source.getShape()[ii] - (offset[ii] + rangeEnd)));
    var sourceIndex = List.generate(index.length, (i) => index[i] + offset[i]);
    sourceIndex[ii] = index[ii];
    v.addAll(List.filled(preCount, defaultValue!));
    v.addAll(source.getRange(sourceIndex, rangeStart + offset[ii] + preCount,
        rangeEnd + offset[ii] - postCount));
    v.addAll(List.filled(postCount, defaultValue!));
    return v;
  }

  T get(List<int> index) {
    if (index.length != shape.length) {
      throw Exception("index has wrong dimension");
    }
    for (int i = 0; i < index.length; i++) {
      if (index[i] + offset[i] < 0 ||
          index[i] + offset[i] >= source.getShape()[i]) {
        if (defaultValue == null) {
          throw Exception("index out of bounds");
        } else {
          return defaultValue!;
        }
      }
    }
    return source.get(List.generate(index.length, (i) => index[i] + offset[i]));
  }

  List<T> getData() {
    throw Exception("not implemented");
  }
}

class DynMatrix<T> implements Matrix<T> {
  List<dynamic> data;
  List<dynamic>? data2;
  List<int> shape;
  List<int> dimFactors;
  T? defaultValue;

  DynMatrix(
      this.data, this.data2, this.shape, this.dimFactors, this.defaultValue);

  List<T> getRange(List<int> index, int rangeStart, int rangeEnd) {
    int ii = 0;
    for (int i = 0; i < index.length; i++) {
      if (index[i] < 0) {
        ii = i;
        break;
      }
    }
    var indexBase = sum(List.generate(
        index.length, (i) => i == ii ? 0 : index[i] * dimFactors[i]));
    var factor = dimFactors[ii];

    if (factor == 1) {
      return data
          .sublist(indexBase + rangeStart, indexBase + rangeEnd)
          .cast<T>();
    }

    var v = <T>[];
    for (int i = rangeStart; i < rangeEnd; i++) {
      v.add(data[factor * i + indexBase]);
    }
    return v;
  }

  T get(List<int> index) {
    if (index.length != shape.length) {
      throw Exception("index has wrong dimension");
    }
    for (int i = 0; i < index.length; i++) {
      if (index[i] < 0 || index[i] >= shape[i]) {
        if (defaultValue == null) {
          throw Exception("index out of bounds");
        } else {
          return defaultValue!;
        }
      }
    }
    return data[
        sum(List.generate(index.length, (i) => index[i] * dimFactors[i]))];
  }

  List<int> getShape() {
    return shape;
  }

  List<T> getData() {
    return data.cast<T>();
  }

  Matrix<S> nextGeneration<S>(
      S Function(Matrix<T>) f, List<int> size, T defaultValue) {
    if (shape.first == 0) {
      return DynMatrix([], [], [], [], null);
    }
    if (data2 == null) {
      data2 = List.filled(data.length, 0);
    }
    var data3 = data2!;
    var i = 0;
    var index = List.filled(shape.length, 0);
    var viewMatrixShape = size.map((s) => s * 2 + 1).toList();
    var viewMatrix = MatrixView(
        this, viewMatrixShape, size.map((e) => -e).toList(), defaultValue);

    while (true) {
      for (; index[0] < shape.first; index[0]++) {
        data3[i] = f(viewMatrix);
        viewMatrix.offset[0]++;
        i++;
      }
      var depth = 0;
      index[depth] = shape.first - 1;
      while (depth < shape.length && index[depth] == shape[depth] - 1) {
        index[depth] = 0;
        viewMatrix.offset[depth] = -size[depth];
        depth++;
      }
      if (depth == shape.length) {
        return DynMatrix(data3, data, shape, dimFactors, null);
      }
      index[depth]++;
      viewMatrix.offset[depth]++;
    }
  }

  static DynMatrix<T> fromIterable<T>(Iterable matrix) {
    var shape = [-1];
    var shapeCheck = [1];
    var currentIter = matrix.iterator;

    if (!currentIter.moveNext()) {
      return DynMatrix([], [], [], [], null);
    }

    var iters = [currentIter];
    var data = <dynamic>[];

    while (currentIter.current is Iterable) {
      currentIter = currentIter.current.iterator;
      if (!currentIter.moveNext()) {
        shape.add(0);
        break;
      }
      iters.add(currentIter);
      shape.add(-1);
      shapeCheck.add(1);
    }

    if (shape.last != 0) {
      data.add(currentIter.current);
    }

    while (iters.isNotEmpty) {
      currentIter = iters.last;
      if (!currentIter.moveNext()) {
        var dimSize = shape[iters.length - 1];
        var dimSizeCheck = shapeCheck.removeLast();
        if (dimSize == -1) {
          shape[iters.length - 1] = dimSizeCheck;
        } else if (dimSize != dimSizeCheck) {
          throw Exception("matrix cannot have different sized dimensions");
        }
        iters.removeLast();
      } else {
        shapeCheck[shapeCheck.length - 1] += 1;
        if (currentIter.current is Iterable) {
          iters.add(currentIter.current.iterator);
          shapeCheck.add(0);
        } else {
          data.add(currentIter.current);
        }
      }
    }

    shape = shape.reversed.toList();
    var dimFactors = shape.sublist(0, shape.length - 1).fold<List<int>>(
        [1], (l, s) => also<List<int>>(l, (l) => l.add(s * l.last)));

    return DynMatrix(data, null, shape, dimFactors, null);
  }

  List toLists() {
    var l = [];
    var toFill = l;
    for (int i = 0; i < shape.length - 1; i++) {
      var newToFill = [];
      toFill.add(newToFill);
      toFill = newToFill;
    }
    if (shape.isEmpty || shape.first == 0) {
      return l;
    }
    var index = List.filled(shape.length, 0);

    while (true) {
      for (int i = 0; i < shape.first; i++) {
        toFill.add(get(index));
      }
      var depth = 0;
      index[depth] = shape.first - 1;
      while (depth < shape.length && index[depth] == shape[depth] - 1) {
        index[depth] = 0;
        depth++;
      }
      if (depth == shape.length) {
        return l;
      }
      index[depth]++;
      toFill = l;
      for (int i = 0; i < shape.length - depth - 1; i++) {
        toFill = toFill.last;
      }
      depth--;
      for (; depth >= 0; depth--) {
        var newToFill = [];
        toFill.add(newToFill);
        toFill = newToFill;
      }
    }
  }
}

void testMatrix() {
  var t1 = [
    [2],
    [3]
  ];
  var t2 = [
    [
      [
        [
          [2],
          [2]
        ],
        [
          [3],
          [3]
        ]
      ]
    ]
  ];
  DynMatrix<int> matrix = DynMatrix.fromIterable(t1);
  print(t1);
  print(matrix.toLists());
  print(t2);
  print(DynMatrix.fromIterable(t2).toLists());
}

List<List<T>> nextGeneration<S, T>(List<List<S>> matrix,
    T Function(List<List<S>>) f, int size, S defaultValue) {
  List<List<T>> newMatrix = [];
  List<S> defaultVec = List.generate(size * 2 + 1, (index) => defaultValue);
  for (int j = 0; j < matrix.length; j++) {
    var vec = matrix[j];
    List<T> newVec = [];
    newMatrix.add(newVec);
    for (int i = 0; i < vec.length; i++) {
      List<List<S>> kernel = [];
      for (int x = 0; x < size - j; x++) {
        kernel.add(defaultVec);
      }
      for (int x = -min(j, size); x < min(matrix.length - j, size + 1); x++) {
        List<S> v = [];
        for (int y = 0; y < size - i; y++) {
          v.add(defaultValue);
        }
        for (int y = -min(i, size); y < min(vec.length - i, size + 1); y++) {
          v.add(matrix[j + x][i + y]);
        }
        for (int y = 0; y < size - (vec.length - i - 1); y++) {
          v.add(defaultValue);
        }
        kernel.add(v);
      }
      for (int x = 0; x < size - (matrix.length - j - 1); x++) {
        kernel.add(defaultVec);
      }
      //print(kernel.toString());
      newVec.add(f(kernel));
    }
  }
  return newMatrix;
}

List<String> characters(String str) {
  var chars = <String>[];
  for (var x = 0; x < str.length; x++) {
    chars.add(str.substring(x, x + 1));
  }

  return chars;
}

T also<T>(T x, Function(T) f) {
  f(x);
  return x;
}

class Graph<T> {
  HashSet<T> nodes;
  Map<T, HashSet<T>> edges;
  Graph(this.nodes, this.edges);

  static Graph<T> fromEdges<T>(Iterable<List<T>> edges) {
    var nodes = HashSet<T>.from([]);
    var edgesG = <T, HashSet<T>>{};

    for (var edge in edges) {
      var from = edge[0];
      var to = edge[1];
      nodes.addAll(edge);

      edgesG.update(from, (tos) => also(tos, (tos) => tos.add(to)),
          ifAbsent: () => HashSet.from([to]));
    }

    return Graph(nodes, edgesG);
  }
}

int parseInt(String intStr) {
  return int.parse(intStr);
}

dynamic compose(dynamic Function(dynamic) f, dynamic Function(dynamic) f2,
    [dynamic Function(dynamic)? f3,
    dynamic Function(dynamic)? f4,
    dynamic Function(dynamic)? f5]) {
  var f3nn = f3 ?? identity;
  var f4nn = f4 ?? identity;
  var f5nn = f5 ?? identity;
  return (x) => f(f2(f3nn(f4nn(f5nn(x)))));
}

List<T> flatten<T>(List<List<T>> list) {
  return list.expand<T>(identity).toList();
}

T identity<T>(T x) {
  return x;
}

List<int> primes(int n) {
  int nextRangeEnd = 30;
  List<int> p = [];
  primesUntil(nextRangeEnd, p);
  while (p.length < n) {
    nextRangeEnd *= 2;
    primesUntil(nextRangeEnd, p);
  }
  return p.sublist(0, n);
}

void primesUntil(int n, List<int> knownPrimes) {
  if (n < 3) {
    knownPrimes.clear();
    return;
  }

  if (knownPrimes.length < 10) {
    List<int> p = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29];
    knownPrimes.addAll(p.sublist(knownPrimes.length));
  }

  if (n < 31) {
    knownPrimes.retainWhere((e) => e < n);
    return;
  }

  int lastKnownPrime = knownPrimes.last;
  List<bool> mp = List.generate(n - lastKnownPrime - 1, (index) => true);

  for (var e in knownPrimes) {
    for (var i = (lastKnownPrime ~/ e) + 1; i * e < n; i++) {
      mp[i * e - lastKnownPrime - 1] = false;
    }
  }

  for (int i = 0; i < n - lastKnownPrime - 1; i++) {
    if (mp[i]) {
      knownPrimes.add(i + lastKnownPrime + 1);
    }
  }
}

dynamic apply(dynamic f, Iterable args) {
  var a = args.toList();
  switch (a.length) {
    case 0:
      return f();
    case 1:
      return f(a[0]);
    case 2:
      return f(a[0], a[1]);
    case 3:
      return f(a[0], a[1], a[2]);
    case 4:
      return f(a[0], a[1], a[2], a[3]);
    case 5:
      return f(a[0], a[1], a[2], a[3], a[4]);
  }
  throw Exception("apply only supports functions up to 5 arguments");
}

class Hints {
  Pattern? groupSeparator = "\n\n";
  Pattern? lineSeparator = "\n";
  dynamic atomSeparator; // Pattern or List<Pattern> to separate the atoms
  String?
      atomHint; // hint how the atoms should be parsed: "string", "int", "codeUnits", "counter", "counterUnits"
  bool isGraph = false; // build a Graph from the atoms
  bool isBiGraph = false; // build a BiGraph from the atoms
  bool lineAtoms = false; // atom is the complete line
  dynamic atomParser; // function for parsing the atom
  String Function(String)?
      beforeLine; // function executed before a line is parsed
  String Function(String)?
      beforeLines; // function executed before lines within a group are splitted
  dynamic onAtom; // function performed on atom after parse
}

//List<A> smartParse1<A>(String str,
//    {Hints? globalHints, List<Hints?>? groupHints}) {
//  return (smartParse(str, globalHints: globalHints, groupHints: groupHints)
//          as List)
//      .cast<A>();
//}
//
//List<List<A>> smartParse2<A>(String str,
//    {Hints? globalHints, List<Hints?>? groupHints}) {
//  return (smartParse(str, globalHints: globalHints, groupHints: groupHints)
//          as List)
//      .map((e) => (e as List).cast<A>())
//      .toList();
//}
//
//List<List<List<A>>> smartParse3<A>(String str,
//    {Hints? globalHints, List<Hints?>? groupHints}) {
//  return (smartParse(str, globalHints: globalHints, groupHints: groupHints)
//          as List)
//      .map((e) => (e as List).map((e) => (e as List).cast<A>()).toList())
//      .toList();
//}
//
//List<List<List<List<A>>>> smartParse4<A>(String str,
//    {Hints? globalHints, List<Hints?>? groupHints}) {
//  return (smartParse(str, globalHints: globalHints, groupHints: groupHints)
//          as List)
//      .map((e) => (e as List)
//          .map((e) => (e as List).map((e) => (e as List).cast<A>()).toList())
//          .toList())
//      .toList();
//}

dynamic smartParse<T>(String str,
    {Hints? globalHints, List<Hints?>? groupHints}) {
  var spr = SmartParseResult(
      _smartParse(str, globalHints: globalHints, groupHints: groupHints));
  spr.flattened<T>();
  return spr.result;
}

dynamic _smartParse(String str,
    {Hints? globalHints, List<Hints?>? groupHints}) {
  dynamic parseAtom(String atom, Hints hints) {
    switch (hints.atomHint) {
      case "string":
        return atom;
      case "int":
        return parseInt(atom);
      case "codeUnits":
        return atom.codeUnits;
      case "codeUnit":
        return atom.codeUnitAt(0);
      case "counter":
        return count(characters(atom));
      case "codeUnitsCounter":
        return count(atom.codeUnits);
    }

    var n = num.tryParse(atom);
    if (n != null) {
      return n;
    }
    return atom;
  }

  dynamic parseLine(String line, Hints hints) {
    var atomParser = hints.atomParser ?? (atom) => parseAtom(atom, hints);
    var parser = atomParser;
    if (hints.onAtom != null) {
      parser = (atom) => hints.onAtom(atomParser(atom));
    }
    var atoms = [];
    var separator = hints.atomSeparator;
    if (hints.lineAtoms) {
      atoms.add(parser(line));
    } else if (separator == null) {
      for (var potentialSeparator in [" ", ",", "--", "-", "|"]) {
        if (line.contains(potentialSeparator)) {
          separator = potentialSeparator;
          atoms.addAll(line.split(separator).map(parser));
          break;
        }
      }
      if (separator == null) {
        atoms.add(parser(line));
      }
    } else {
      if (separator is List) {
        atoms.addAll(line.split(separator.first));
        for (var aSeparator in separator.sublist(1)) {
          atoms = mapLeaves(atoms, (atom) => atom.split(aSeparator));
        }
        atoms = mapLeaves(atoms, parser);
      } else {
        atoms.addAll(line.split(separator).map(parser));
      }
    }
    if (hints.isGraph) {
      atoms = [Graph.fromEdges(atoms.cast<List>())];
    } else if (hints.isBiGraph) {
      atoms = [
        Graph.fromEdges(atoms.expand<List>((e) => [
              e,
              [e[1], e[0]]
            ]))
      ];
    }
    return atoms;
  }

  dynamic parseLineGroup(String linesStr, Hints hints) {
    var res;
    var separator = hints.lineSeparator;
    var beforeLines = hints.beforeLines ?? identity;
    var aLinesStr = beforeLines(linesStr);
    var beforeLine = hints.beforeLine ?? identity;
    var lines = [aLinesStr];
    if (separator != null) {
      lines = aLinesStr.split(separator);
    }
    return lines.map((line) => parseLine(beforeLine(line), hints)).toList();
  }

  var aGlobalHints = globalHints ?? Hints();
  var separator = aGlobalHints.groupSeparator;
  var groups = separator == null ? [str] : str.split(separator);

  List<Hints?> aGroupHints = groupHints ?? [];
  var result = [];
  for (int i = 0; i < groups.length; i++) {
    var hints = i < aGroupHints.length && aGroupHints[i] != null
        ? aGroupHints[i]!
        : aGlobalHints;
    result.add(parseLineGroup(groups[i], hints));
  }
  return result;
}

class SmartParseResult {
  dynamic result;

  SmartParseResult(this.result);

  void cast<T>() {
    for (int i = 0; i < result.length; i++) {
      for (int j = 0; j < result[i].length; j++) {
        result[i][j] = result[i][j].cast<T>();
      }
      result[i] = result[i].cast<List<T>>();
    }
    result = result.cast<List<List<T>>>();
  }

  void flattened<T>() {
    bool flattenLines = true;
    bool flattenAtoms = true;
    bool stop = false;
    for (int i = 0; i < result.length; i++) {
      if (flattenAtoms) {
        for (int j = 0; j < result[i].length; j++) {
          if (result[i][j].length != 1) {
            flattenAtoms = false;
          }
          break;
        }
      }
      if (flattenLines && result[i].length != 1) {
        flattenLines = false;
      }
      if (!flattenLines && !flattenAtoms) {
        break;
      }
    }
    if (flattenAtoms && flattenLines) {
      // [[[1]], [[2]], [[3]], [[4]], [[5]], [[6]]]
      result = getLeaves(result).cast<T>();
    } else if (flattenAtoms) {
      // [[[1], [2]], [[3]], [[4], [5], [6]]]
      for (int i = 0; i < result.length; i++) {
        for (int j = 0; j < result[i].length; j++) {
          result[i][j] = result[i][j][0];
        }
        result[i] = result[i].cast<T>();
      }
      result = result.cast<List<T>>();
    } else if (flattenLines) {
      // [[[1, 2]], [[3]]. [[4, 5, 6]]]
      for (int i = 0; i < result.length; i++) {
        result[i] = result[i][0].cast<T>();
      }
      result = result.cast<List<T>>();
    } else {
      cast<T>();
    }
    if (result.length == 1) {
      result = result[0];
    }
  }
}

//class DynamicBox<T> {
//  dynamic strucutre;
//  List<List<T>> view;
//
//  DynamicBox._(this.strucutre, this.view);
//
//  static DynamicBox<T> from(dynamic strucutre) {
//    return DynamicBox._(strucutre, deepCoerce<T>(strucutre) as List<T>);
//  }
//}
//
//class DynamicBox2<S, T> {
//  dynamic strucutre;
//}
//
//dynamic deepCoerce<T>(dynamic structure) {
//  if (structure is List) {
//  } else if (structure is Set) {}
//}

List<Tuple<S, T>> zip<S, T>(List<S> l1, List<T> l2) {
  var len = min(l1.length, l2.length);
  List<Tuple<S, T>> r = [];
  for (int i = 0; i < len; i++) {
    r.add(Tuple(l1[i]!, l2[i]!));
  }
  return r;
}

T get0<T>(List<T> list) {
  return list[0];
}

T get1<T>(List<T> list) {
  return list[1];
}

T get2<T>(List<T> list) {
  return list[2];
}

T get3<T>(List<T> list) {
  return list[3];
}

List<T> mapToList<S, T>(List<S> list, T Function(S) f) {
  return list.map((e) => f(e)).toList();
}

List<List<T>> deepMap2<S, T>(List<List<S>> list, T Function(S) f) {
  return list.map((e) => e.map(f).toList()).toList();
}

List<List<List<T>>> deepMap3<S, T>(List<List<List<S>>> list, T Function(S) f) {
  return list.map((e) => e.map((e) => e.map(f).toList()).toList()).toList();
}

List<List<List<List<T>>>> deepMap4<S, T>(
    List<List<List<List<S>>>> list, T Function(S) f) {
  return list
      .map((e) =>
          e.map((e) => e.map((e) => e.map(f).toList()).toList()).toList())
      .toList();
}

List mapLeaves(List list, dynamic f) {
  return list.map((e) => e is List ? mapLeaves(e, f) : f(e)).toList();
}

List getLeaves(List list) {
  var leaves = [];
  var lists = [list];
  while (lists.isNotEmpty) {
    var nextList = lists.removeAt(0);
    for (var elem in nextList) {
      if (elem is List) {
        lists.add(elem);
      } else {
        leaves.add(elem);
      }
    }
  }
  return leaves;
}

class Tuple<S, T> {
  //implements Iterable<dynamic> {
  S x;
  T y;
  Tuple(this.x, this.y);

  static Tuple<dynamic, dynamic> fromIterable(Iterable elems) {
    var iter = elems.iterator;
    iter.moveNext();
    var x = iter.current;
    iter.moveNext();
    return Tuple(x, iter.current);
  }

  @override
  String toString() {
    return "[$x, $y]";
  }
}

class SetWith<T> {
  List<T> set = [];
  Set<int> hashes = {};
  int Function(T) hash;

  SetWith(this.hash);

  static SetWith<T> fromIterable<T>(
      Iterable<T> elements, int Function(T) hash) {
    var sw = SetWith<T>(hash);
    sw.addAll(elements);
    return sw;
  }

  void addAll(Iterable<T> elements) {
    for (var element in elements) {
      add(element);
    }
  }

  void add(T element) {
    var h = hash(element);
    var l = hashes.length;
    hashes.add(h);
    if (hashes.length != l) {
      set.add(element);
    }
  }

  int get length => set.length;
}

int reverseCompareTo(dynamic x, dynamic y) {
  return y.compareTo(x);
}

List<T> asList<T>(dynamic list) {
  return (list as List).cast<T>();
}

List<List<T>> asList2<T>(dynamic list) {
  return list.map<List<T>>((list2) => (list2 as List).cast<T>()).toList();
}

List<List<List<T>>> asList3<T>(dynamic list) {
  return list
      .map<List<List<T>>>((list2) =>
          list2.map<List<T>>((list3) => (list3 as List).cast<T>()).toList())
      .toList();
}

List<T> reversed<T>(List<T> list) {
  return list.reversed.toList();
}

num inc(num a) {
  return a + 1;
}

num dec(num a) {
  return a - 1;
}

abstract class StringTransformerBuilder {}

class MasterTransformerBuilder implements StringTransformerBuilder {}
