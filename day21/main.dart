import 'dart:io';

class Monkey {
  int? number;
  String? left, operator, right;

  Monkey(final Monkey monkey) {
    this.number = monkey.number;
    this.left = monkey.left;
    this.operator = monkey.operator;
    this.right = monkey.right;
  }

  Monkey.number(this.number);

  Monkey.operation(this.left, this.operator, this.right);
}

int? calc(int left, int right, final Monkey monkey) {
  switch (monkey.operator) {
    case '+':
      {
        return left + right;
      }
    case '-':
      {
        return left - right;
      }
    case '*':
      {
        return left * right;
      }
    case '/':
      {
        return left ~/ right;
      }
  }

  return null;
}

void one(final Map<String, Monkey> M) {
  while (M['root']?.number == null) {
    M.forEach((key, monkey) {
      if (monkey.number == null && M[monkey.left]?.number != null && M[monkey.right]?.number != null) {
        monkey.number = calc(M[monkey.left]!.number!, M[monkey.right]!.number!, monkey);
      }
    });
  }

  print(M['root']!.number);
}

void two(final Map<String, Monkey> O, int start, int end) {
  final Map<String, Monkey> M = copy(O);
  M['humn']!.number = (start + end) ~/ 2;

  while (M[M['root']!.left]?.number == null || M[M['root']!.right]?.number == null) {
    M.forEach((key, monkey) {
      if (monkey.number == null && M[monkey.left]?.number != null && M[monkey.right]?.number != null) {
        monkey.number = calc(M[monkey.left]!.number!, M[monkey.right]!.number!, monkey);
      }
    });
  }

  if (start < end) {
    // change signs if result not found
    if (M[M['root']!.left]!.number! > M[M['root']!.right]!.number!) {
      two(O, (start + end) ~/ 2 + 1, end);
    } else if (M[M['root']!.left]!.number! <= M[M['root']!.right]!.number!) {
      two(O, start, (start + end) ~/ 2 - 1);
    }
  } else {
    print((start + end) ~/ 2);
  }
}

Map<String, Monkey> copy(final Map<String, Monkey> M) {
  return M.map((key, value) => MapEntry(key, Monkey(value)));
}

void main() {
  Map<String, Monkey> M = Map();
  File('input.txt').readAsLinesSync().forEach((String line) {
    List<String> f = line.split(':');
    List<String> s = f[1].trim().split(' ');
    M[f[0]] = (s.length > 1 ? Monkey.operation(s[0], s[1], s[2]) : Monkey.number(int.parse(s[0])));
  });

  one(copy(M));
  two(copy(M), 0, 100000000000000000);
}
