import 'dart:io';

const int size = 24;
List<List<List<bool>>> C = List.generate(size, (_) => List.generate(size, (_) => List.generate(size, (_) => false)));
const List<int> di = [-1, 1, 0, 0, 0, 0], dj = [0, 0, -1, 1, 0, 0], dz = [0, 0, 0, 0, -1, 1];

void read() {
  File('input.txt').readAsLinesSync().forEach((String line) {
    C[int.parse(line.split(',')[0]) + 1][int.parse(line.split(',')[1]) + 1][int.parse(line.split(',')[2]) + 1] = true;
  });
}

int getNeighboursNumber(final List<List<List<bool>>> Cubes, final int i, final int j, final int z) {
  int neighbours = 0;
  for (int k = 0; k < 6; k++) {
    int ii = i + di[k], jj = j + dj[k], zz = z + dz[k];
    if (ii >= 0 && ii < size && jj >= 0 && jj < size && zz >= 0 && zz < size && Cubes[ii][jj][zz]) {
      neighbours++;
    }
  }
  return neighbours;
}

void one(final List<List<List<bool>>> Cubes) {
  int sol = 0;
  for (int i = 0; i < size; i++) {
    for (int j = 0; j < size; j++) {
      for (int z = 0; z < size; z++) {
        if (!Cubes[i][j][z]) {
          sol += getNeighboursNumber(Cubes, i, j, z);
        }
      }
    }
  }
  print(sol);
}

void fill(final List<List<List<bool>>> F, final List<List<List<bool>>> Cubes, final int i, final int j, final int z) {
  F[i][j][z] = false;
  for (int k = 0; k < 6; k++) {
    int ii = i + di[k], jj = j + dj[k], zz = z + dz[k];
    if (ii >= 0 && ii < size && jj >= 0 && jj < size && zz >= 0 && zz < size && !Cubes[ii][jj][zz] && F[ii][jj][zz]) {
      fill(F, Cubes, ii, jj, zz);
    }
  }
}

void two(final List<List<List<bool>>> Cubes) {
  List<List<List<bool>>> F = List.generate(size, (_) => List.generate(size, (_) => List.generate(size, (_) => true)));
  fill(F, C, 0, 0, 0);
  one(F);
}

void main() {
  read();
  one(C);
  two(C);
}
