import 'dart:io';
import 'dart:math';

int manhattan(final int x1, final int y1, final int x2, final int y2) {
  return (x1 - x2).abs() + (y1 - y2).abs();
}

int isCovered(final List<List<int>> sensorsAndBeacons, final int x, final int y) {
  for (List<int> sensorAndBeacon in sensorsAndBeacons) {
    if (manhattan(sensorAndBeacon[0], sensorAndBeacon[1], x, y) <= sensorAndBeacon[4]) {
      return 1;
    }
  }
  return 0;
}

void one(final List<List<int>> sensorsAndBeacons) {
  int positive = 0, stop = 0, sol = 0;
  sensorsAndBeacons.forEach((List<int> sensorAndBeacon) {
    sensorAndBeacon.add(manhattan(sensorAndBeacon[0], sensorAndBeacon[1], sensorAndBeacon[2], sensorAndBeacon[3]));
    positive = max(positive, sensorAndBeacon[4]);
    stop = max(stop, sensorAndBeacon[0]);
  });
  for (int x = -positive; x < stop + positive; x++) {
    sol += isCovered(sensorsAndBeacons, x, 2000000);
  }
  print(sol - 1);
}

bool isInside(final int value) {
  return !(value < 0 || value > 4000000);
}

void two(final List<List<int>> sensorsAndBeacons) {
  for (List<int> sb in sensorsAndBeacons) {
    for (int x = 0, y = sb[4] + 1; x <= sb[4] + 1; x++, y--) {
      List<int> edges = [sb[0] + x, sb[1] + y, sb[0] + x, sb[1] - y, sb[0] - x, sb[1] + y, sb[0] - x, sb[1] - y];
      for (int i = 0; i < 8; i += 2) {
        if (isInside(edges[i]) && isInside(edges[i + 1]) && isCovered(sensorsAndBeacons, edges[i], edges[i + 1]) == 0) {
          print(edges[i] * 4000000 + edges[i + 1]);
          return;
        }
      }
    }
  };
}

void main() {
  List<List<int>> sensorsAndBeacons = File('input.txt')
      .readAsLinesSync()
      .map((String line) => [
            line.split('=')[1].split(',')[0],
            line.split('=')[2].split(':')[0],
            line.split('=')[3].split(',')[0],
            line.split('=')[4],
          ].map((String number) => int.parse(number)).toList())
      .toList();
  one(sensorsAndBeacons);
  two(sensorsAndBeacons);
}
