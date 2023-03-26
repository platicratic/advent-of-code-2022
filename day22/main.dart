import 'dart:io';
import 'dart:math';

const List<int> di = [0, 1, 0, -1], dj = [1, 0, -1, 0];

late int n, m;
List<String> map = [];
String path = '';

void read() {
  int c = 0, r = 0;
  File('input.txt').readAsLinesSync().forEach((String line) {
    if (line.length > 0) {
      c = max(c, line.length);
      r++;
    } else {
      n = r;
      m = c;
    }
  });
  File('input.txt').readAsLinesSync().forEach((String line) {
    if (line.length > 0) {
      if (path.isEmpty) {
        map.add(line + ' ' * (m - line.length));
      } else {
        path = line;
      }
    } else {
      path = 'next time set the path';
    }
  });
}

List<int> moveOne(final int pi, final int pj, final int d) {
  int i = pi + di[d];
  int j = pj + dj[d];
  if (i < 0) {
    i = n - 1;
  } else if (j < 0) {
    j = m - 1;
  } else if (i == n) {
    i = 0;
  } else if (j == m) {
    j = 0;
  }

  return [i, j];
}

void one() {
  int pi = 0, pj = 0, d = 0;
  for (int j = 0; j < m; j++) {
    if (map[0][j] != ' ') {
      pj = j;
      break;
    }
  }

  List<int> pa = path.split(RegExp('[LR]')).map((String it) => int.parse(it)).toList();
  List<String> pr = path.split(RegExp('[0-9]+')).skip(1).toList();
  for (int p = 0; p < pa.length; p++) {
    while (pa[p]-- > 0) {
      int i = moveOne(pi, pj, d)[0];
      int j = moveOne(pi, pj, d)[1];
      while (map[i][j] == ' ') {
        i = moveOne(i, j, d)[0];
        j = moveOne(i, j, d)[1];
      }
      if (map[i][j] == '.') {
        pi = i;
        pj = j;
      }
    }

    switch (pr[p]) {
      case 'L':
        {
          d = (d + 3) % 4;
          break;
        }
      case 'R':
        {
          d = (d + 1) % 4;
          break;
        }
    }
  }

  print(1000 * (pi + 1) + 4 * (pj + 1) + d);
}

/*
 12
 3
45
6
*/

int nothing(final int value, final int _) {
  return value;
}

int zero(final int value, final int _) {
  return 0;
}

int fifty(final int value, final int _) {
  return 49;
}

int reverse(final int value, final int _) {
  return 49 - value;
}

int swap(final int first, final int second) {
  return second;
}

List<List<Function>> I = [
  [nothing, zero, reverse, swap],
  [reverse, swap, nothing, fifty],
  [fifty, zero, zero, fifty],
  [nothing, zero, reverse, swap],
  [reverse, swap, nothing, fifty],
  [fifty, zero, zero, fifty]
];
List<List<Function>> J = [
  [zero, nothing, zero, zero],
  [fifty, fifty, fifty, nothing],
  [swap, nothing, swap, nothing],
  [zero, nothing, zero, zero],
  [fifty, fifty, fifty, nothing],
  [swap, nothing, swap, nothing]
];
List<List<int>> D = [
  [0, 1, 0, 0],
  [2, 2, 2, 3],
  [3, 1, 1, 3],
  [0, 1, 0, 0],
  [2, 2, 2, 3],
  [3, 1, 1, 3]
];
List<List<int>> C = [
  [1, 2, 3, 5],
  [4, 2, 0, 5],
  [1, 4, 3, 0],
  [4, 5, 0, 2],
  [1, 5, 3, 2],
  [4, 1, 0, 3]
];

List<int> moveTwo(final int pi, final int pj, final int pd, final int pc) {
  int i = pi + di[pd];
  int j = pj + dj[pd];
  if (j == 50 || i == 50 || i < 0 || j < 0) {
    return [I[pc][pd](i, j), J[pc][pd](j, i), D[pc][pd], C[pc][pd]];
  }
  return [i, j, pd, pc];
}

void two() {
  List<List<String>> cube = [];
  for (int i = 0; i < map.length; i += 50) {
    for (int j = 0; j < 150; j += 50) {
      if (map[i][j] != ' ') {
        cube.add(map.sublist(i, i + 50).map((String it) => it.substring(j, j + 50)).toList());
      }
    }
  }

  int i = 0, j = 0, d = 0, c = 0;
  List<int> pa = path.split(RegExp('[LR]')).map((String it) => int.parse(it)).toList();
  List<String> pr = path.split(RegExp('[0-9]+')).skip(1).toList();
  for (int p = 0; p < pa.length; p++) {
    while (pa[p]-- > 0) {
      List<int> ijdc = moveTwo(i, j, d, c);
      if (cube[ijdc[3]][ijdc[0]][ijdc[1]] == '.') {
        i = ijdc[0];
        j = ijdc[1];
        d = ijdc[2];
        c = ijdc[3];
      }
    }

    d = (d + (pr[p] == 'L' ? 3 : 1)) % 4;
  }

  final List<int> OffsetI = [0, 0, 50, 100, 100, 150];
  final List<int> OffsetJ = [50, 100, 50, 0, 50, 0];
  print(1000 * (i + OffsetI[c] + 1) + 4 * (j + OffsetJ[c] + 1) + d);
}

void main() {
  read();
  one();
  two();
}
