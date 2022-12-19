import 'dart:io';
import 'dart:math';

int depth = 0;
List<List<bool>> createCave() {
  List<List<List<int>>> rocks = File('input.txt')
      .readAsLinesSync()
      .map((String line) => line
          .split('->')
          .map((String coordinates) => coordinates.trim().split(',').map((String axis) => int.parse(axis)).toList())
          .toList())
      .toList();
  rocks.forEach((List<List<int>> line) {
    line.forEach((List<int> coordinate) {
      depth = max(depth, coordinate[1]);
    });
  });
  List<List<bool>> cave = List.generate(depth + 2, (_) => List.generate(500 + depth + 3, (_) => false));
  cave.add(List.generate(500 + depth + 3, (_) => true));
  rocks.forEach((List<List<int>> coordinates) {
    for (int i = 0; i < coordinates.length - 1; i ++) {
      for (int j = 0; j < 2; j ++) {
        while (coordinates[i][j] < coordinates[i + 1][j]) {
          cave[coordinates[i][1]][coordinates[i][0]] = true;
          coordinates[i][j] ++;
        }
        while (coordinates[i][j] > coordinates[i + 1][j]) {
          cave[coordinates[i][1]][coordinates[i][0]] = true;
          coordinates[i][j] --;
        }
      }
      cave[coordinates[i][1]][coordinates[i][0]] = true;
    }
  });
  return cave;
}

void fall(final List<List<bool>> cave, final List<int> sand) {
  cave[sand[0]][sand[1]] = false;
  if (!cave[sand[0] + 1][sand[1]]) {
    cave[sand[0] + 1][sand[1]] = true;
  }
  else if (!cave[sand[0] + 1][sand[1] - 1]) {
    cave[sand[0] + 1][sand[1] - 1] = true;
    sand[1] --;
  }
  else if (!cave[sand[0] + 1][sand[1] + 1]) {
    cave[sand[0] + 1][sand[1] + 1] = true;
    sand[1] ++;
  }
  sand[0] ++;
}

void one(final List<List<bool>> cave) {
  int sol = 0;
  while (true) {
    List<int> sand = [0, 500];
    while (!cave[sand[0] + 1][sand[1]] || !cave[sand[0] + 1][sand[1] - 1] || !cave[sand[0] + 1][sand[1] + 1]) {
      fall(cave, sand);
      if (sand[0] == depth) break;
    }
    if (sand[0] == depth) break;
    sol ++;
  }
  print(sol);
}

void two(final List<List<bool>> cave) {
  int sol = 1;
  while (true) {
    List<int> sand = [0, 500];
    while (!cave[sand[0] + 1][sand[1]] || !cave[sand[0] + 1][sand[1] - 1] || !cave[sand[0] + 1][sand[1] + 1]) {
      fall(cave, sand);
    }
    if (sand[0] == 0) break;
    sol ++;
  }
  print(sol);
}

void main() {
  one(createCave());
  two(createCave());
}
