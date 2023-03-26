import 'dart:io';
import 'dart:math';

class Pair {
  int x, y;

  Pair(this.x, this.y);

  @override
  bool operator ==(final Object other) {
    return (other is Pair && other.x == x && other.y == y);
  }

  @override
  int get hashCode => Object.hash(x, y);
}

Map<String, Pair> directions = {
  'NW': Pair(-1, -1),
  'N': Pair(-1, 0),
  'NE': Pair(-1, 1),
  'E': Pair(0, 1),
  'SE': Pair(1, 1),
  'S': Pair(1, 0),
  'SW': Pair(1, -1),
  'W': Pair(0, -1),
};

List<List<bool>> createGrove(final int offset) {
  List<String> rawGrove = File("input.txt").readAsLinesSync();
  List<List<bool>> grove =
      List.generate(rawGrove.length + offset * 2, (_) => List.generate(rawGrove.first.length + offset * 2, (_) => false));
  for (int i = 0; i < rawGrove.length; i++) {
    for (int j = 0; j < rawGrove[i].length; j++) {
      grove[i + offset][j + offset] = (rawGrove[i][j] == '#');
    }
  }
  return grove;
}

bool consider8(final List<List<bool>> grove, final int i, final int j) {
  for (Pair direction in directions.values) {
    if (grove[i + direction.x][j + direction.y]) {
      return true;
    }
  }
  return false;
}

bool consider4(final List<List<bool>> grove, final List<dynamic> four, final int i, final int j) {
  for (int k = 1; k < 4; k++) {
    if (grove[i + (four[k] as Pair).x][j + (four[k] as Pair).y]) {
      return true;
    }
  }
  return false;
}

void one(final List<List<bool>> grove) {
  List<List<dynamic>> four = [
    ['N', directions['N']!, directions['NE']!, directions['NW']!],
    ['S', directions['S']!, directions['SE']!, directions['SW']!],
    ['W', directions['W']!, directions['NW']!, directions['SW']!],
    ['E', directions['E']!, directions['NE']!, directions['SE']!]
  ];
  for (int t = 0; t < 10; t++) {
    List<Pair> from = [], to = [];
    Map<Pair, int> count = {};
    for (int i = 0; i < grove.length; i++) {
      for (int j = 0; j < grove[i].length; j++) {
        if (grove[i][j]) {
          if (!consider8(grove, i, j)) continue;
          for (int k = 0; k < 4; k++) {
            if (!consider4(grove, four[k], i, j)) {
              from.add(Pair(i, j));
              to.add(Pair(i + directions[four[k].first as String]!.x, j + directions[four[k].first as String]!.y));
              count[to.last] = count.containsKey(to.last) ? count[to.last]! + 1 : 1;
              break;
            }
          }
        }
      }
    }
    for (int k = 0; k < from.length; k++) {
      if (count[to[k]]! == 1) {
        grove[from[k].x][from[k].y] = false;
        grove[to[k].x][to[k].y] = true;
      }
    }
    four.add(four.first);
    four.removeAt(0);
  }
  int x1 = 0x3f3f3f3f, x2 = 0, y1 = 0x3f3f3f3f, y2 = 0, nr = 0;
  for (int i = 0; i < grove.length; i++) {
    for (int j = 0; j < grove[i].length; j++) {
      if (grove[i][j]) {
        x1 = min(x1, i);
        x2 = max(x2, i);
        y1 = min(y1, j);
        y2 = max(y2, j);
        nr++;
      }
    }
  }

  print((y2 - y1 + 1) * (x2 - x1 + 1) - nr);
}

void two(final List<List<bool>> grove) {
  List<List<dynamic>> four = [
    ['N', directions['N']!, directions['NE']!, directions['NW']!],
    ['S', directions['S']!, directions['SE']!, directions['SW']!],
    ['W', directions['W']!, directions['NW']!, directions['SW']!],
    ['E', directions['E']!, directions['NE']!, directions['SE']!]
  ];
  int t = 0, moves = 0;
  do {
    t ++;
    moves = 0;
    List<Pair> from = [], to = [];
    Map<Pair, int> count = {};
    for (int i = 0; i < grove.length; i++) {
      for (int j = 0; j < grove[i].length; j++) {
        if (grove[i][j]) {
          if (!consider8(grove, i, j)) continue;
          for (int k = 0; k < 4; k++) {
            if (!consider4(grove, four[k], i, j)) {
              from.add(Pair(i, j));
              to.add(Pair(i + directions[four[k].first as String]!.x, j + directions[four[k].first as String]!.y));
              count[to.last] = count.containsKey(to.last) ? count[to.last]! + 1 : 1;
              break;
            }
          }
        }
      }
    }
    for (int k = 0; k < from.length; k++) {
      if (count[to[k]]! == 1) {
        grove[from[k].x][from[k].y] = false;
        grove[to[k].x][to[k].y] = true;
        moves ++;
      }
    }
    four.add(four.first);
    four.removeAt(0);
  } while (moves > 0);

  print(t);
}

void main() {
  one(createGrove(10));
  two(createGrove(100));
}
