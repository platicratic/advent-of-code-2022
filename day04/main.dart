import 'dart:io';

void partOne(final List<List<int>> sections) {
  int sol = 0;
  for (List<int> section in sections) {
    if ((section[0] >= section[2] && section[1] <= section[3]) ||
        (section[2] >= section[0] && section[3] <= section[1])) {
      sol++;
    }
  }
  print(sol);
}

void partTwo(final List<List<int>> sections) {
  int sol = 0;
  for (List<int> section in sections) {
    if ((section[2] >= section[0] && section[2] <= section[1]) ||
        (section[3] >= section[0] && section[3] <= section[1]) ||
        (section[0] >= section[2] && section[1] <= section[3]) ||
        (section[2] >= section[0] && section[3] <= section[1])) {
      sol++;
    }
  }
  print(sol);
}

void main() {
  List<List<int>> sections = File('input.txt')
      .readAsLinesSync()
      .map((String item) => item
          .replaceAll(RegExp(','), '-')
          .split('-')
          .map((String item) => int.parse(item))
          .toList())
      .toList();
  partOne(sections);
  partTwo(sections);
}
