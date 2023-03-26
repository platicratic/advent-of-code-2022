import 'dart:io';
import 'dart:math';

late List<List<int>> blueprint;
late int geodes, id, minutes;
late List<List<List<List<List<List<List<int>>>>>>> F;

void read() {
  blueprint = File('input.txt').readAsLinesSync().map((String line) {
    List<String> split = line.split(' ');
    return [
      int.parse(split[6]),
      int.parse(split[12]),
      int.parse(split[18]),
      int.parse(split[21]),
      int.parse(split[27]),
      int.parse(split[30])
    ];
  }).toList();
  blueprint.insert(0, []);
  generate();
}

bool shouldBuyOreRobot(final int min, final int ore, final int oreRobot) {
  int remaining = (minutes - min);
  int max = ore + oreRobot * remaining;
  return (max < blueprint[id][1] * remaining ||
      max < blueprint[id][2] * remaining ||
      max < blueprint[id][4] * remaining);
}

bool canBuyOreRobot(final int ore) {
  return (blueprint[id][0] <= ore);
}

bool shouldBuyClayRobot(final int min, final int clay, final int clayRobot) {
  int remaining = (minutes - min);
  return (clay + clayRobot * remaining < blueprint[id][3] * remaining);
}

bool canBuyClayRobot(final int ore) {
  return (blueprint[id][1] <= ore);
}

bool shouldBuyObsidianRobot(final int min, final int obsidian, final int obsidianRobot) {
  int remaining = (minutes - min);
  return (obsidian + obsidianRobot * remaining < blueprint[id][5] * remaining);
}

bool canBuyObsidianRobot(final int ore, final int clay) {
  return (blueprint[id][2] <= ore && blueprint[id][3] <= clay);
}

bool canBuyGeodeRobot(final int ore, final int obsidian) {
  return (blueprint[id][4] <= ore && blueprint[id][5] <= obsidian);
}

bool better(int min, int ore, int clay, int obsidian, int oreRobot, int clayRobot, int obsidianRobot, int geode,
    int geodeRobot) {
  if (minutes < 32) return true;
  if (ore > 4) ore = 5;
  if (clay > 20) clay = 21;
  if (obsidian > 20) obsidian = 21;
  if (oreRobot > 4) oreRobot = 5;
  if (clayRobot > 20) clayRobot = 21;
  if (obsidianRobot > 20) obsidianRobot = 21;

  if (F[min][ore][clay][obsidian][oreRobot][clayRobot][obsidianRobot] < geode + geodeRobot * (minutes - min)) {
    F[min][ore][clay][obsidian][oreRobot][clayRobot][obsidianRobot] = geode + geodeRobot * (minutes - min);
    return true;
  }
  return false;
}

void every(final int min, final int ore, final int clay, final int obsidian, final int geode, final int oreRobot,
    final int clayRobot, final int obsidianRobot, final int geodeRobot) {
  if (better(min, ore, clay, obsidian, oreRobot, clayRobot, obsidianRobot, geode, geodeRobot)) {
    if (min < minutes - 2) {
      if (canBuyOreRobot(ore) && shouldBuyOreRobot(min, ore, oreRobot)) {
        every(min + 1, ore - blueprint[id][0] + oreRobot, clay + clayRobot, obsidian + obsidianRobot,
            geode + geodeRobot, oreRobot + 1, clayRobot, obsidianRobot, geodeRobot);
      }
      if (canBuyClayRobot(ore) && shouldBuyClayRobot(min, clay, clayRobot)) {
        every(min + 1, ore - blueprint[id][1] + oreRobot, clay + clayRobot, obsidian + obsidianRobot,
            geode + geodeRobot, oreRobot, clayRobot + 1, obsidianRobot, geodeRobot);
      }
      if (canBuyObsidianRobot(ore, clay) && shouldBuyObsidianRobot(min, obsidian, obsidianRobot)) {
        every(min + 1, ore - blueprint[id][2] + oreRobot, clay - blueprint[id][3] + clayRobot, obsidian + obsidianRobot,
            geode + geodeRobot, oreRobot, clayRobot, obsidianRobot + 1, geodeRobot);
      }
      if (canBuyGeodeRobot(ore, obsidian)) {
        every(min + 1, ore - blueprint[id][4] + oreRobot, clay + clayRobot, obsidian - blueprint[id][5] + obsidianRobot,
            geode + geodeRobot, oreRobot, clayRobot, obsidianRobot, geodeRobot + 1);
      }
      every(min + 1, ore + oreRobot, clay + clayRobot, obsidian + obsidianRobot, geode + geodeRobot, oreRobot,
          clayRobot, obsidianRobot, geodeRobot);
    } else if (min < minutes - 1) {
      if (canBuyOreRobot(ore)) {
        every(min + 1, ore - blueprint[id][0] + oreRobot, clay + clayRobot, obsidian + obsidianRobot,
            geode + geodeRobot, oreRobot + 1, clayRobot, obsidianRobot, geodeRobot);
      }
      if (canBuyObsidianRobot(ore, clay)) {
        every(min + 1, ore - blueprint[id][2] + oreRobot, clay - blueprint[id][3] + clayRobot, obsidian + obsidianRobot,
            geode + geodeRobot, oreRobot, clayRobot, obsidianRobot + 1, geodeRobot);
      }
      if (canBuyGeodeRobot(ore, obsidian)) {
        every(min + 1, ore - blueprint[id][4] + oreRobot, clay + clayRobot, obsidian - blueprint[id][5] + obsidianRobot,
            geode + geodeRobot, oreRobot, clayRobot, obsidianRobot, geodeRobot + 1);
      }
      every(min + 1, ore + oreRobot, clay + clayRobot, obsidian + obsidianRobot, geode + geodeRobot, oreRobot,
          clayRobot, obsidianRobot, geodeRobot);
    } else if (min < minutes) {
      if (canBuyGeodeRobot(ore, obsidian)) {
        every(min + 1, ore - blueprint[id][4] + oreRobot, clay + clayRobot, obsidian - blueprint[id][5] + obsidianRobot,
            geode + geodeRobot, oreRobot, clayRobot, obsidianRobot, geodeRobot + 1);
      }
      every(min + 1, ore + oreRobot, clay + clayRobot, obsidian + obsidianRobot, geode + geodeRobot, oreRobot,
          clayRobot, obsidianRobot, geodeRobot);
    } else {
      geodes = max(geodes, geode + geodeRobot);
    }
  }
}

void generate() {
  F = List.generate(
    33,
    (_) => List.generate(
      6,
      (_) => List.generate(
        22,
        (_) => List.generate(
          22,
          (_) => List.generate(
            6,
            (_) => List.generate(
              22,
              (_) => List.generate(
                22,
                (_) => -1,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

void reset() {
  print('Reset started.');
  geodes = 0;
  for (int i1 = 0; i1 < 33; i1++) {
    for (int i2 = 0; i2 < 6; i2++) {
      for (int i3 = 0; i3 < 22; i3++) {
        for (int i4 = 0; i4 < 22; i4++) {
          for (int i5 = 0; i5 < 6; i5++) {
            for (int i6 = 0; i6 < 22; i6++) {
              for (int i7 = 0; i7 < 22; i7++) {
                F[i1][i2][i3][i4][i5][i6][i7] = -1;
              }
            }
          }
        }
      }
    }
  }
  print('Reset done.');
}

void one() {
  minutes = 24;
  int sol = 0;
  for (id = 1; id < blueprint.length; id++) {
    geodes = 0;
    every(1, 0, 0, 0, 0, 1, 0, 0, 0);
    print('Blueprint: $id -> $geodes geodes.');
    sol += id * geodes;
  }
  print('Part I: $sol.');
}

void two() {
  minutes = 32;
  int sol = 1;
  for (id = 1; id < 4; id++) {
    reset();
    every(1, 0, 0, 0, 0, 1, 0, 0, 0);
    print('Blueprint: $id -> $geodes geodes.');
    sol *= geodes;
  }
  print('Part II: $sol.');
}

void main() {
  read();
  one();
  two();
}
