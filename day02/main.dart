import 'dart:io';

Map<String, int> M1 = {
  'X': 1,
  'Y': 2,
  'Z': 3,
  'AX': 3,
  'AY': 6,
  'AZ': 0,
  'BX': 0,
  'BY': 3,
  'BZ': 6,
  'CX': 6,
  'CY': 0,
  'CZ': 3,
};

Map<String, int> M2 = {
  'AX': 3,
  'AY': 4,
  'AZ': 8,
  'BX': 1,
  'BY': 5,
  'BZ': 9,
  'CX': 2,
  'CY': 6,
  'CZ': 7,
};

void partOne(final List<List<String>> rounds) {
  int score = 0;
  rounds.forEach((List<String> round) {
    score += M1[round[1]]! + M1[round[0] + round[1]]!;
  });
  print(score);
}

void partTwo(final List<List<String>> rounds) {
  int score = 0;
  rounds.forEach((List<String> round) {
    score += M2[round[0] + round[1]]!;
  });
  print(score);
}

void main() {
  List<List<String>> rounds = File('input.txt').readAsLinesSync().map((String item) => item.split(' ')).toList();
  partOne(rounds);
  partTwo(rounds);
}
