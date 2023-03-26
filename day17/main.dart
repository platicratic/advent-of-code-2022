import 'dart:io';

List<List<List<bool>>> rocks = [
  [
    [true, true, true, true]
  ],
  [
    [false, true, false],
    [true, true, true],
    [false, true, false]
  ],
  [
    [false, false, true],
    [false, false, true],
    [true, true, true]
  ],
  [
    [true],
    [true],
    [true],
    [true]
  ],
  [
    [true, true],
    [true, true]
  ]
];

void addRock(final List<List<bool>> chamber, List<List<bool>> rock) {
  for (int i = 0; i < 3 + rock.length; i++) {
    chamber.insert(0, List.generate(7, (_) => false));
  }
  for (int i = 0; i < rock.length; i++) {
    for (int j = 0; j < rock[i].length; j++) {
      chamber[i][j + 2] = rock[i][j];
    }
  }
}

bool canMoveLeft(final List<List<bool>> chamber, final List<List<bool>> rock, final int pi, final int pj) {
  for (int i = pi; i < rock.length + pi; i++) {
    for (int j = pj; j < rock[i - pi].length + pj; j++) {
      if (chamber[i][j] && rock[i - pi][j - pj]) {
        if (j == 0 || chamber[i][j - 1]) {
          return false;
        }
        break;
      }
    }
  }
  return true;
}

bool moveLeft(final List<List<bool>> chamber, final List<List<bool>> rock, final int pi, final int pj) {
  if (canMoveLeft(chamber, rock, pi, pj)) {
    for (int i = pi; i < rock.length + pi; i++) {
      for (int j = pj; j < rock[i - pi].length + pj; j++) {
        if (chamber[i][j] && rock[i - pi][j - pj]) {
          chamber[i][j - 1] = chamber[i][j];
          chamber[i][j] = false;
        }
      }
    }
    return true;
  }
  return false;
}

bool canMoveRight(final List<List<bool>> chamber, final List<List<bool>> rock, final int pi, final int pj) {
  for (int i = pi; i < rock.length + pi; i++) {
    for (int j = pj + rock[i - pi].length - 1; j >= pj; j--) {
      if (chamber[i][j] && rock[i - pi][j - pj]) {
        if (j == 6 || chamber[i][j + 1]) {
          return false;
        }
        break;
      }
    }
  }
  return true;
}

bool moveRight(final List<List<bool>> chamber, final List<List<bool>> rock, final int pi, final int pj) {
  if (canMoveRight(chamber, rock, pi, pj)) {
    for (int i = pi; i < rock.length + pi; i++) {
      for (int j = pj + rock[i - pi].length - 1; j >= pj; j--) {
        if (chamber[i][j] && rock[i - pi][j - pj]) {
          chamber[i][j + 1] = chamber[i][j];
          chamber[i][j] = false;
        }
      }
    }
    return true;
  }
  return false;
}

bool canMoveDown(final List<List<bool>> chamber, final List<List<bool>> rock, final int pi, final int pj) {
  if (chamber.length <= rock.length + pi) return false;
  for (int j = pj; j < rock.first.length + pj; j++) {
    for (int i = pi + rock.length - 1; i >= pi; i--) {
      if (chamber[i][j] && rock[i - pi][j - pj]) {
        if (chamber[i + 1][j]) {
          return false;
        }
        break;
      }
    }
  }
  return true;
}

bool moveDown(final List<List<bool>> chamber, final List<List<bool>> rock, final int pi, final int pj) {
  if (canMoveDown(chamber, rock, pi, pj)) {
    for (int j = pj; j < rock.first.length + pj; j++) {
      for (int i = pi + rock.length - 1; i >= pi; i--) {
        if (chamber[i][j] && rock[i - pi][j - pj]) {
          chamber[i + 1][j] = chamber[i][j];
          chamber[i][j] = false;
        }
      }
    }
    return true;
  }
  return false;
}

void printChamber(List<List<bool>> chamber) {
  for (int i = 0; i < chamber.length; i++) {
    String l = '';
    for (int j = 0; j < chamber[i].length; j++) {
      l += (chamber[i][j] ? '@' : '.');
    }
    print(l);
  }
  print('\n');
}

bool isBlank(final List<bool> line) {
  for (bool it in line) {
    if (it) {
      return false;
    }
  }
  return true;
}

List<List<bool>> tetris(int rock, int jet, int number) {
  List<List<bool>> chamber = [];
  while (number-- > 0) {
    addRock(chamber, rocks[rock]);
    int i = 0, j = 2;
    while (true) {
      if (Jet[jet] == '<') {
        if (moveLeft(chamber, rocks[rock], i, j)) j--;
      } else {
        if (moveRight(chamber, rocks[rock], i, j)) j++;
      }
      jet = (jet + 1) % Jet.length;

      if (moveDown(chamber, rocks[rock], i, j)) {
        i++;
        if (isBlank(chamber[0])) {
          chamber.removeAt(0);
          i--;
        }
      } else {
        break;
      }
    }
    rock = (rock + 1) % 5;
  }
  return chamber;
}

void one() {
  List<List<bool>> chamber = tetris(0, 0, 2022);
  print(chamber.length);
}

bool equal(List<bool> a, List<bool> b) {
  for (int i = 0; i < 7; i++) {
    if (a[i] != b[i]) {
      return false;
    }
  }
  return true;
}

bool isPattern(final List<List<bool>> chamber, final int i, final int k) {
  for (int i1 = i, i2 = i + k; i1 < i + k; i1++, i2++) {
    if (!equal(chamber[i1], chamber[i2])) {
      return false;
    }
  }
  return true;
}

void findPattern() {
  List<List<bool>> chamber = tetris(0, 0, 5000);
  chamber = chamber.reversed.toList();

  int start = 0, rate = 0;
  for (int k = 53; k < 2700; k++) {
    for (int i = 0; i < chamber.length - (k * 2); i++) {
      if (isPattern(chamber, i, k)) {
        if (i == 0 && k == 53) {
          print("hei");
        }
        bool ultimatePattern = true;
        for (int j = i + k; j < chamber.length - (k * 2); j += k) {
          if (!isPattern(chamber, j, k)) {
            ultimatePattern = false;
            break;
          }
        }
        if (ultimatePattern) {
          start = i;
          rate = k;
          k = 0x3f3f3f3f;
          i = 0x3f3f3f3f;
        }
      }
    }
  }
  print('starting: $start');
  print('repeats: $rate');
}

bool equals(final List<List<bool>> chamber1, final List<List<bool>> chamber2, final int size) {
  if (chamber2.length < size) return false;
  for (int i = 0; i < size; i++) {
    for (int j = 0; j < 7; j++) {
      if (chamber1[i][j] != chamber2[i][j]) {
        return false;
      }
    }
  }
  return true;
}

int getNumberOfRocksForSpecificHeight(final List<List<bool>> chamber1, int rock, int jet, final int height) {
  List<List<bool>> chamber2 = [];
  int sol = 0;
  while (!equals(chamber1, chamber2.reversed.toList(), height)) {
    addRock(chamber2, rocks[rock]);
    int i = 0, j = 2;
    while (true) {
      if (Jet[jet] == '<') {
        if (moveLeft(chamber2, rocks[rock], i, j)) j--;
      } else {
        if (moveRight(chamber2, rocks[rock], i, j)) j++;
      }
      jet = (jet + 1) % Jet.length;

      if (moveDown(chamber2, rocks[rock], i, j)) {
        i++;
        if (isBlank(chamber2[0])) {
          chamber2.removeAt(0);
          i--;
        }
      } else {
        break;
      }
    }
    rock = (rock + 1) % 5;
    sol++;
  }
  return sol;
}

void findRocksPerPattern(final int start, final int repeats) {
  List<List<bool>> chamber = tetris(0, 0, start + repeats + repeats).reversed.toList();
  print('beginning: ${getNumberOfRocksForSpecificHeight(chamber, 0, 0, start)}');
  print('first pattern: ${getNumberOfRocksForSpecificHeight(chamber, 0, 0, start + repeats)}');
  print('second pattern: ${getNumberOfRocksForSpecificHeight(chamber, 0, 0, start + repeats + repeats)}');
}

void two() {
  //findPattern(); // example: 25-53. test: 383-2647
  //findRocksPerPattern(383, 2647); // example 15-35. test: 257-1730
  print(((1000000000000 - 257) ~/ 1730) * 2647 + tetris(0, 0, 257 + ((1000000000000 - 257) % 1730)).length);
}

String Jet = File('input.txt').readAsStringSync();

void main() {
  one();
  two();
}
