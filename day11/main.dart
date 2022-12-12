import 'dart:io';

class Monkey {
  final List<int> items;
  final int test, ifTrue, ifFalse;
  final Function operation;
  int count = 0;

  Monkey(this.items, this.operation, this.test, this.ifTrue, this.ifFalse);
}

List<Monkey> read() {
  List<Monkey> monkeys = [];
  /*List<Function> operations = [
    (final int old) => old * 17,
    (final int old) => old * old,
    (final int old) => old + 7,
    (final int old) => old + 4,
    (final int old) => old + 5,
    (final int old) => old + 6,
    (final int old) => old * 13,
    (final int old) => old + 2,
  ];*/
  List<Function> operations = [
        (final int old) => old * 19,
        (final int old) => old + 6,
        (final int old) => old * old,
        (final int old) => old + 3,
  ];
  List<String> lines = File('input.txt').readAsLinesSync();
  for (int i = 0; i < lines.length; i += 7) {
    monkeys.add(Monkey(
      lines[i + 1].split(':')[1].split(',').map((String number) => int.parse(number.trim())).toList(),
      operations[i ~/ 7],
      int.parse(lines[i + 3].split(' ').last),
      int.parse(lines[i + 4].split(' ').last),
      int.parse(lines[i + 5].split(' ').last),
    ));
  }
  return monkeys;
}

void one(final List<Monkey> monkeys) {
  for (int i = 0; i < 1; i ++) {
    for (Monkey monkey in monkeys) {
      for (int item in monkey.items) {
        item = monkey.operation(item) ~/ 3;
        monkeys[(item % monkey.test == 0 ? monkey.ifTrue : monkey.ifFalse)].items.add(item);
      }
      monkey.count += monkey.items.length;
      monkey.items.clear();
    }
  }
  List<int> inspects = monkeys.map((Monkey monkey) => monkey.count).toList();
  print(inspects);
  inspects.sort();
  print(inspects[inspects.length - 2] * inspects.last);
}

void two(final List<Monkey> monkeys) {
  for (int i = 0; i < 1000; i ++) {
    for (Monkey monkey in monkeys) {
      for (int item in monkey.items) {
        item = monkey.operation(item) % 666013; // probabil cel mai mic multiplu comun aici
        monkeys[(item % monkey.test == 0 ? monkey.ifTrue : monkey.ifFalse)].items.add(item);
      }
      monkey.count += monkey.items.length;
      monkey.items.clear();
    }
  }
  List<int> inspects = monkeys.map((Monkey monkey) => monkey.count).toList();
  print(inspects);
  //print(monkeys[0].items);
  inspects.sort();
  print(inspects[inspects.length - 2] * inspects.last);
}

void main() {
  one(read());
  two(read());
}
