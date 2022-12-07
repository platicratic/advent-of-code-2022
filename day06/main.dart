import 'dart:io';

bool different4(final int start, final int end, final String buffer) {
  if (start < end) {
    for (int i = start + 1; i <= end; i ++) {
      if (buffer[start] == buffer[i]) {
        return false;
      }
    }
    return different4(start + 1, end, buffer);
  }
  return true;
}

void partOne(final String buffer) {
  for (int i = 3; i < buffer.length; i ++) {
    if (different4(i - 3, i, buffer)) {
      print(i + 1);
      break;
    }
  }
}

void partTwo(final String buffer) {
  for (int i = 13; i < buffer.length; i ++) {
    if (different4(i - 13, i, buffer)) {
      print(i + 1);
      break;
    }
  }
}

void main() {
  String buffer = File('input.txt').readAsStringSync();
  partOne(buffer);
  partTwo(buffer);
}