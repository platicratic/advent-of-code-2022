import 'dart:io';
import 'dart:math';

void partOne(final List<int> days) {
  print(days.reduce((value, element) => value = max(value, element)));
}

void partTwo(final List<int> days) {
  List<int> maxim = [0, 0, 0];
  for (int day in days) {
    for (int i = 0; i < 3; i ++) {
      if (day > maxim[i]) {
        maxim.insert(i, day);
        break;
      }
    }
  }
  print(maxim[0] + maxim[1] + maxim[2]);
}

void main() {
  List<String> calories = File('input.txt').readAsLinesSync();
  List<int> days = [];
  int sum = 0;
  for (int i = 0; i < calories.length; i++) {
    if (calories[i].isEmpty) {
      days.add(sum);
      sum = 0;
    }
    else {
      sum += int.parse(calories[i]);
    }
  }
  days.add(sum);
  partOne(days);
  partTwo(days);
}
