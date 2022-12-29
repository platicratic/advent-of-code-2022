import 'dart:io';
import 'dart:math';

int withPressure = 0;
Map<String, int> H = Map(), HH = Map();
Map<int, int> Pressure = Map();
Map<int, List<String>> Graph = Map();
late List<List<Map<String, int>>> Best;

void read() {
  int d = 1;
  H['AA'] = 0;
  File('input.txt').readAsLinesSync().forEach((line) {
    String key = line.substring(6, 8);
    if (!H.containsKey(key)) {
      H[key] = d++;
    }
    int v = int.parse(line.split('=')[1].split(';')[0]);
    List<String> g = line.split('valve')[1].replaceAll(',', '').split(' ').skip(1).toList();
    Pressure[H[key]!] = v;
    Graph[H[key]!] = g;

    if (v > 0) HH[key] = withPressure++;
  });
  Best = List.generate(31, (_) => List.generate(H.length, (_) => Map()));
}

bool isOpen(final String opened, final String toOpen) {
  for (int i = 0; i < opened.length; i += 2) {
    if (opened[i] == toOpen[0] && opened[i + 1] == toOpen[1]) {
      return true;
    }
  }
  return false;
}

Map<String, int> OpenedPressure = Map();

int calculate(final String opened) {
  if (OpenedPressure.containsKey(opened)) {
    return OpenedPressure[opened]!;
  }
  int openedPressure = 0;
  for (int i = 0; i < opened.length; i += 2) {
    openedPressure += Pressure[H[opened[i] + opened[i + 1]]]!;
  }
  OpenedPressure[opened] = openedPressure;
  return openedPressure;
}

void solve(final int minute, final String node, final String opened) {
  if (minute < 30) {
    if (Pressure[H[node]!]! > 0 && !isOpen(opened, node)) {
      String newOpened = opened + node;
      int pressure = Best[minute][H[node]!][opened]! + calculate(newOpened);
      if (!Best[minute + 1][H[node]!].containsKey(newOpened) || Best[minute + 1][H[node]!][newOpened]! < pressure) {
        Best[minute + 1][H[node]!][newOpened] = pressure;
        solve(minute + 1, node, newOpened);
      }
    }
    int pressure = Best[minute][H[node]!][opened]! + calculate(opened);
    for (String g in Graph[H[node]]!) {
      if (!Best[minute + 1][H[g]!].containsKey(opened) || Best[minute + 1][H[g]!][opened]! < pressure) {
        Best[minute + 1][H[g]!][opened] = pressure;
        solve(minute + 1, g, opened);
      }
    }
  }
}

void one() {
  Best[1][0][''] = 0;
  solve(1, 'AA', '');

  int best = 0;
  Best[30].forEach((Map<String, int> it) => it.values.forEach((int jt) => best = max(best, jt)));
  print(best);
}

List<bool> prepareEquality(final List<int> C) {
  List<bool> F = List.generate(withPressure, (_) => false);
  for (int i = 1; i < C.length; i ++) {
    F[C[i]] = true;
  }
  return F;
}

bool notEqual(final List<bool> F, final List<int> C) {
  for (int i = 1; i < C.length; i ++) {
    if (F[C[i]]) {
      return false;
    }
  }
  return true;
}

void two() {
  // major optimization, you don't need the stop positions, ~100 times faster
  Map<String, int> M = Map();
  List<List<int>> Steroids = [];
  Best[26].forEach((Map<String, int> best) {
    best.forEach((oa, a) {
      if (!M.containsKey(oa) || M[oa]! < a) {
        M[oa] = a;
      }
    });
  });

  // minor optimization, from there the name, ~20 times faster
  M.forEach((oa, a) {
    List<int> Steroid = [a];
    for (int i = 0; i < oa.length; i += 2) {
      Steroid.add(HH[oa[i] + oa[i + 1]]!);
    }
    Steroids.add(Steroid);
  });

  int best = 0;
  for (List<int> a in Steroids) {
    List<bool> F = prepareEquality(a);
    for (List<int> b in Steroids) {
      if (notEqual(F, b)) {
        best = max(best, a[0] + b[0]);
      }
    }
  }
  print(best);
}

void main() {
  read();
  one();
  two();
}
