import 'dart:io';

void one(final List<int> instructions) {
  const List<int> Cycles = [20, 60, 100, 140, 180, 220];
  int register = 1, strength = 0;
  for (int c = 0; c < 220; c++) {
    register += instructions[c];
    if (Cycles.contains(c + 1)) {
      strength += (c + 1) * register;
    }
  }
  print(strength);
}

void two(final List<int> instructions) {
  String result = '';
  for (int i = 0, c = 0, register = 0; i < 6; i ++) {
    for (int j = 0; j < 40; j ++, c ++) {
      register += instructions[c];
      result += (j >= register && j < register + 3 ? '#' : '.');
    }
    result += '\n';
  }
  print(result);
}

void main() {
  List<int> instructions = [0];
  File('input.txt').readAsLinesSync().forEach((String line) {
    instructions.add(0);
    if (line[0] == 'a') {
      instructions.add(int.parse(line.split(' ')[1]));
    }
  });
  one(instructions);
  two(instructions);
}
