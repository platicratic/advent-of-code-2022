import 'dart:io';

int getNumberLength(final String l) {
  int len = 0;
  while (len < l.length && l[len].codeUnitAt(0) >= '0'.codeUnitAt(0) && l[len].codeUnitAt(0) <= '9'.codeUnitAt(0)) {
    len++;
  }
  return len;
}

bool check(final String l1, final String l2) {
  if (l1.isEmpty || (l1[0] == ']' && l2[0] != ']')) return true;
  if (l2.isEmpty || (l1[0] != ']' && l2[0] == ']')) return false;
  if ((l1[0] == ',' && l2[0] == ',') || (l1[0] == '[' && l2[0] == '[') || (l1[0] == ']' && l2[0] == ']')) {
    return check(l1.substring(1), l2.substring(1));
  }
  if (l1[0] == '[' && l2[0] != '[') {
    return check(l1, '[' + l2.substring(0, getNumberLength(l2)) + ']' + l2.substring(getNumberLength(l2)));
  }
  if (l1[0] != '[' && l2[0] == '[') {
    return check('[' + l1.substring(0, getNumberLength(l1)) + ']' + l1.substring(getNumberLength(l1)), l2);
  }
  int left = int.parse(l1.substring(0, getNumberLength(l1)));
  int right = int.parse(l2.substring(0, getNumberLength(l2)));
  if (left < right) return true;
  if (left > right) return false;

  return check(l1.substring(getNumberLength(l1)), l2.substring(getNumberLength(l2)));
}

void one(final List<String> lines) {
  int sol = 0;
  for (int i = 0, index = 1; i < lines.length; i += 2, index++) {
    if (check(lines[i], lines[i + 1])) {
      sol += index;
    }
  }
  print(sol);
}

void two(final List<String> lines) {
  const List<String> dividers = ['[[2]]', '[[6]]'];
  lines.addAll(dividers);
  lines.sort((l1, l2) => (check(l1, l2) ? -1 : 1));
  print((lines.indexOf(dividers[0]) + 1) * (lines.indexOf(dividers[1]) + 1));
}

void main() {
  List<String> lines = File('input.txt').readAsLinesSync().where((String line) => line.isNotEmpty).toList();
  one(lines);
  two(lines);
}
