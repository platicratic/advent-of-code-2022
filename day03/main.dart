import 'dart:io';

void partOne(final List<String> rucksacks) {
  int sum = 0;
  for (String rucksack in rucksacks) {
    Set<String> S = {};
    for (int i = 0; i < rucksack.length ~/ 2; i ++) {
      S.add(rucksack[i]);
    }
    for (int i = rucksack.length ~/ 2; i < rucksack.length; i ++) {
      if (S.contains(rucksack[i])) {
        sum += M[rucksack[i]]!;
        break;
      }
    }
  }
  print(sum);
}

void partTwo(final List<String> rucksacks) {
  int sum = 0;
  for (int i = 0; i < rucksacks.length; i += 3) {
    Map<String, int> H = {};
    for (int j = 0; j < 3; j ++) {
      for (int k = 0; k < rucksacks[i + j].length; k ++) {
        if ((H[rucksacks[i + j][k]] != null && H[rucksacks[i + j][k]] == j) || (H[rucksacks[i + j][k]] == null && j == 0)) {
          H[rucksacks[i + j][k]] = j + 1;
        }
      }
    }
    sum += M[H.entries.singleWhere((MapEntry<String, int> item) => item.value == 3).key]!;
  }
  print(sum);
}

void createMap() {
  for (int i = 0; i < 26; i ++) {
    M[String.fromCharCode('a'.codeUnitAt(0) + i)] = i + 1;
    M[String.fromCharCode('A'.codeUnitAt(0) + i)] = i + 27;
  }
}

Map<String, int> M = {};

void main() {
  List<String> rucksacks = File('input.txt').readAsLinesSync();
  createMap();
  partOne(rucksacks);
  partTwo(rucksacks);
}
