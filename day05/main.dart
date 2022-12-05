import 'dart:io';

List<List<String>> test = [
  [],
  ['Z', 'N'],
  ['M', 'C', 'D'],
  ['P']
];

List<List<String>> puzzle = [
  [],
  ['B', 'V', 'S', 'N', 'T', 'C', 'H', 'Q'],
  ['W', 'D', 'B', 'G'],
  ['F', 'W', 'R', 'T', 'S', 'Q', 'B'],
  ['L', 'G', 'W', 'S', 'Z', 'J', 'D', 'N'],
  ['M', 'P', 'D', 'V', 'F'],
  ['F', 'W', 'J'],
  ['L', 'N', 'Q', 'B', 'J', 'V'],
  ['G', 'T', 'R', 'C', 'J', 'Q', 'S', 'N'],
  ['J', 'S', 'Q', 'C', 'W', 'D', 'M'],
];

void partOne(final List<List<int>> moves, final List<List<String>> stack) {
  String sol = '';
  for (List<int> move in moves) {
    int start = stack[move[1]].length - move[0];
    stack[move[2]].addAll(stack[move[1]].sublist(start).reversed);
    stack[move[1]].removeRange(start, stack[move[1]].length);
  }
  stack.skip(1).forEach((List<String> pile) { sol += pile.last; });
  print(sol);
}

void partTwo(final List<List<int>> moves, final List<List<String>> stack) {
  String sol = '';
  for (List<int> move in moves) {
    int start = stack[move[1]].length - move[0];
    stack[move[2]].addAll(stack[move[1]].sublist(start));
    stack[move[1]].removeRange(start, stack[move[1]].length);
  }
  stack.skip(1).forEach((List<String> pile) { sol += pile.last; });
  print(sol);
}

void main() {
  List<List<int>> moves =
      File('input.txt').readAsLinesSync().map((String line) {
    List<String> divided = line.split(' ');
    divided.removeWhere((String item) => item.startsWith(RegExp('[a-z]')));
    return divided.map((item) => int.parse(item)).toList();
  }).toList();

  partOne(moves, [...puzzle.map((it) => [...it])]);
  partTwo(moves, [...puzzle.map((it) => [...it])]);
}
