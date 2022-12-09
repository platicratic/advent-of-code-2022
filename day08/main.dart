import 'dart:io';
import 'dart:math';

const List<int> di = [-1, 0, 1, 0], dj = [0, 1, 0, -1];

bool isInside(final List<List<int>> trees, final int i, final int j) {
  return i >= 0 && j >= 0 && i < trees.length && j < trees.first.length;
}

bool isVisible(final List<List<int>> trees, final int i, final int j) {
  for (int k = 0; k < 4; k++) {
    int ii = i + di[k];
    int jj = j + dj[k];
    while (isInside(trees, ii, jj)) {
      if (trees[ii][jj] >= trees[i][j]) {
        break;
      }
      ii += di[k];
      jj += dj[k];
    }
    if (!isInside(trees, ii, jj)) {
      return true;
    }
  }
  return false;
}

void one(final List<List<int>> trees, {int sol = 0}) {
  for (int i = 0; i < trees.length; i++) {
    for (int j = 0; j < trees[i].length; j++) {
      if (isVisible(trees, i, j)) {
        sol++;
      }
    }
  }
  print(sol);
}

int calculateScore(final List<List<int>> trees, final int i, final int j, {int score = 1}) {
  for (int k = 0; k < 4; k++) {
    int ii = i + di[k];
    int jj = j + dj[k];
    int viewing = 0;
    while (isInside(trees, ii, jj)) {
      viewing ++;
      if (trees[ii][jj] >= trees[i][j]) {
        break;
      }
      ii += di[k];
      jj += dj[k];
    }
    score *= viewing;
  }
  return score;
}

void two(final List<List<int>> trees, {int sol = 0}) {
  for (int i = 0; i < trees.length; i++) {
    for (int j = 0; j < trees[i].length; j++) {
      sol = max(sol, calculateScore(trees, i, j));
    }
  }
  print(sol);
}

void main() {
  List<List<int>> trees = File('input.txt')
      .readAsLinesSync()
      .map((String line) => line.split('').map((item) => int.parse(item)).toList())
      .toList();
  one(trees);
  two(trees);
}
