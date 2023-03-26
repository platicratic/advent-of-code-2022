import 'dart:io';

class Number {
  int id, value;

  Number(this.value, this.id);
}

void solve(final List<Number> originals, int times) {
  List<Number> list = originals.map((Number it) => Number(it.value, it.id)).toList();
  while (times > 0) {
    originals.forEach((Number original) {
      for (int i = 0; i < list.length; i++) {
        if (list[i].id == original.id) {
          Number moved = Number(list[i].value, list[i].id);
          int number = (list[i].value < 0
              ? -(-list[i].value % (list.length - 1)) // this one is strange
              : list[i].value % (list.length - 1));
          list.removeAt(i);
          if (number > 0 && i + number >= list.length) {
            number -= (list.length - i);
            i = 0;
          }
          if (number < 0 && i + number <= 0) {
            number += i;
            i = list.length;
          }
          list.insert(i + number, moved);
          break;
        }
      }
    });
    times--;
  }

  int sol = 0;
  for (int i = 0; i < list.length; i++) {
    if (list[i].value == 0) {
      for (int thousands in [1000, 2000, 3000]) {
        sol += list[(i + thousands) % (list.length)].value;
      }
    }
  }
  print(sol);
}

void one(final List<Number> originals) {
  solve(originals, 1);
}

void two(final List<Number> originals) {
  solve(originals.map((Number number) => Number(number.value * 811589153, number.id)).toList(), 10);
}

void main() {
  int id = 0;
  List<Number> original = File('input.txt').readAsLinesSync().map((String it) => Number(int.parse(it), id++)).toList();
  one(original);
  two(original);
}
