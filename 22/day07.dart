import '../common.dart';

void main() async {
  (await addDay07().solveAll()).printStats();
}

class Dir {
  int? sizeCache;
  List<Dir> children = [];
  Dir? parent;
  bool isDir = true;
  String name;

  Dir(this.parent, this.name);

  int size() {
    if (sizeCache == null) {
      sizeCache = sum(children.map((child) => child.size()));
    }
    return sizeCache!;
  }
}

class File extends Dir {
  File(Dir parent, String name, int size) : super(parent, name) {
    sizeCache = size;
    isDir = false;
  }
}

List<Dir> buildDirs(String input) {
  var lines = splitLines(input);
  var rootDir = Dir(null, "/");
  var dirs = [rootDir];
  var currentDir = rootDir;
  for (var i = 0; i < lines.length; i++) {
    var line = lines[i];
    if (line.startsWith("\$ cd")) {
      var dirName = line.substring(5);
      if (dirName == "/") {
        currentDir = rootDir;
      } else if (dirName == "..") {
        if (currentDir.parent != null) {
          currentDir = currentDir.parent!;
        }
      } else {
        var child = [...currentDir.children];
        child.retainWhere((dir) => dir.name == dirName);
        if (child.length == 1) {
          currentDir = child[0];
        } else {
          currentDir = Dir(currentDir, dirName);
          currentDir.parent!.children.add(currentDir);
          dirs.add(currentDir);
        }
      }
    } else {
      var newFiles = <File>[];
      while (i + 1 < lines.length) {
        i++;
        var lineParts = lines[i].split(" ");
        if (lineParts[0] == "dir") {
          continue;
        } else if (lineParts[0] == "\$") {
          i--;
          break;
        } else {
          var size = parseInt(lineParts[0]);
          var fileName = lineParts[1];
          newFiles.add(File(currentDir, fileName, size));
        }
      }
      var childrenNames =
          mapToList<Dir, String>(currentDir.children, (child) => child.name);
      newFiles.retainWhere((file) => !childrenNames.contains(file.name));
      currentDir.children.addAll(newFiles);
    }
  }
  return dirs;
}

dynamic solveFor07_1(String input) {
  var dirs = buildDirs(input);
  dirs[0].size();
  dirs.retainWhere((dir) => dir.sizeCache! <= 100000);
  return sum(dirs.map((dir) => dir.sizeCache!));
}

dynamic solveFor07_2(String input) {
  var dirs = buildDirs(input);
  var rootSize = dirs[0].size();
  var sizeTarget = 30000000 - (70000000 - rootSize);
  dirs.retainWhere((dir) => dir.sizeCache! >= sizeTarget);
  var smallest = dirs.fold<Dir>(
      dirs[0],
      (previousDir, dir) =>
          dir.sizeCache! < previousDir.sizeCache! ? dir : previousDir);
  return smallest.sizeCache;
}

AOC addDay07({AOC? aoc = null}) {
  aoc = aoc == null ? AOC() : aoc;
  aoc
      .provideSolver("day07_1", solveFor07_1)
      .provideSolver("day07_2", solveFor07_2)
      .provideExpectedResult("day07_1_example", "95437")
      .provideExpectedResult("day07_1_puzzle", "2104783")
      .provideExpectedResult("day07_2_example", "24933642")
      .provideExpectedResult("day07_2_puzzle", "5883165");
  return aoc;
}
