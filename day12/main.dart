import 'dart:collection';
import 'dart:io';
import 'dart:math';

class Position {
  static late Position start, stop;
  int i, j;

  Position(this.i, this.j);

  bool isInside(final int iLength, final int jLength) {
    return i > -1 && i < iLength && j > -1 && j < jLength;
  }
}

int fewest(final List<List<int>> map, final Position start, final Position stop) {
  List<List<int>> best =
      List.generate(map.length, (_) => List.generate(map.first.length, (_) => map.length * map.first.length));
  Queue<Position> queue = Queue();
  best[start.i][start.j] = 0;
  queue.add(start);
  while (queue.isNotEmpty) {
    Position current = queue.removeFirst();
    for (Position k in [Position(-1, 0), Position(0, 1), Position(1, 0), Position(0, -1)]) {
      Position next = Position(current.i + k.i, current.j + k.j);
      if (next.isInside(map.length, map.first.length) && map[current.i][current.j] >= map[next.i][next.j] - 1) {
        if (best[current.i][current.j] + 1 < best[next.i][next.j]) {
          best[next.i][next.j] = best[current.i][current.j] + 1;
          queue.add(next);
        }
      }
    }
  }
  return best[Position.stop.i][Position.stop.j];
}

void one(final List<List<int>> map) {
  print(fewest(map, Position.start, Position.stop));
}

void two(final List<List<int>> map) {
  int result = map.length * map.first.length;
  for (int i = 0; i < map.length; i++) {
    for (int j = 0; j < map[i].length; j++) {
      if (map[i][j] == 'a'.codeUnits.single) {
        result = min(result, fewest(map, Position(i, j), Position.stop));
      }
    }
  }
  print(result);
}

void setStartAndStopPositions(final List<List<int>> map) {
  for (int i = 0; i < map.length; i++) {
    for (int j = 0; j < map[i].length; j++) {
      if (map[i][j] == 'S'.codeUnits.single) {
        map[i][j] = 'a'.codeUnits.single;
        Position.start = Position(i, j);
      } else if (map[i][j] == 'E'.codeUnits.single) {
        Position.stop = Position(i, j);
        map[i][j] = 'z'.codeUnits.single;
      }
    }
  }
}

void main() {
  List<List<int>> map = File('input.txt')
      .readAsLinesSync()
      .map((String line) => line.split('').map((String char) => char.codeUnits.single).toList())
      .toList();
  setStartAndStopPositions(map);
  one(map);
  two(map);
}
